#!/usr/bin/env bash

set -euo pipefail

if [[ ! -f ".env" ]]; then
  echo ".env not found" >&2
  exit 1
fi

source .env

BASE_URL="${NOCODB_BASE_URL}"
BASE_ID="${NOCODB_BASE_ID}"
TOKEN="${NOCODB_API_TOKEN}"
VARIANTS_TABLE_ID="m1r4j89250jexvu"
SPECS_TABLE_ID="mumlsmxsho0do7w"

ensure_column() {
  local column_name="$1"
  local title="$2"
  local uidt="$3"
  local count

  count=$(
    /usr/bin/curl -s -H "xc-token: $TOKEN" \
      "$BASE_URL/api/v1/db/meta/tables/$VARIANTS_TABLE_ID" |
      jq --arg column_name "$column_name" \
        '[.columns[] | select(.column_name == $column_name)] | length'
  )

  if [[ "$count" == "0" ]]; then
    /usr/bin/curl -s -X POST \
      -H "xc-token: $TOKEN" \
      -H "Content-Type: application/json" \
      "$BASE_URL/api/v1/db/meta/tables/$VARIANTS_TABLE_ID/columns" \
      --data "{\"title\":\"$title\",\"column_name\":\"$column_name\",\"uidt\":\"$uidt\"}" >/dev/null
  fi
}

ensure_column "weight_body_g" "weight_body_g" "Decimal"
ensure_column "weight_guy_lines_g" "weight_guy_lines_g" "Decimal"
ensure_column "weight_repair_kit_g" "weight_repair_kit_g" "Decimal"
ensure_column "weight_accessories_g" "weight_accessories_g" "Decimal"
ensure_column "weight_minimum_g" "weight_minimum_g" "Decimal"
ensure_column "weight_packed_g" "weight_packed_g" "Decimal"
ensure_column "weight_displayed_g" "weight_displayed_g" "Decimal"
ensure_column "weight_scope_notes" "weight_scope_notes" "LongText"

variants_json=$(
  /usr/bin/curl -s -H "xc-token: $TOKEN" \
    "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$VARIANTS_TABLE_ID?limit=200"
)

specs_json=$(
  /usr/bin/curl -s -H "xc-token: $TOKEN" \
    "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$SPECS_TABLE_ID?limit=1000"
)

patches=$(
  jq -cn \
    --argjson variants "$variants_json" \
    --argjson specs "$specs_json" '
    def spec_value($tent_id; $key):
      ([ $specs.list[] | select(.tent_id == $tent_id and .key == $key) | .value ][0] // null);

    def spec_note($tent_id):
      [
        spec_value($tent_id; "displayed_weight_scope"),
        spec_value($tent_id; "product_weight_display_scope"),
        spec_value($tent_id; "weight_scope_note"),
        spec_value($tent_id; "weight_variation_note"),
        spec_value($tent_id; "weight_display_scope")
      ] | map(select(. != null and . != "")) | .[0];

    def number_or_null($v):
      if $v == null or $v == "" then null
      elif ($v | type) == "number" then $v
      elif ($v | test("^[0-9]+(\\.[0-9]+)?$")) then ($v | tonumber)
      else null
      end;

    def altaplex_key($suffix):
      ("variant_1p_" + $suffix);

    $variants.list
    | map(
        . as $variant
        | .tent_id as $tent_id
        | {
            id: .Id,
            payload: {
              weight_displayed_g: (.weight_tent_g // number_or_null(spec_value($tent_id; "displayed_tent_weight_g")) // number_or_null(spec_value($tent_id; "product_weight_displayed_g"))),
              weight_body_g:
                (number_or_null(spec_value($tent_id; "tent_body_weight_g"))
                // (if $tent_id == 14 then number_or_null(spec_value($tent_id; altaplex_key("body_weight_g"))) else null end)),
              weight_guy_lines_g:
                (number_or_null(spec_value($tent_id; "guy_lines_weight_g"))
                // (if $tent_id == 14 then number_or_null(spec_value($tent_id; altaplex_key("guy_lines_weight_g"))) else null end)),
              weight_stakes_g:
                (.weight_stakes_g
                // number_or_null(spec_value($tent_id; "stakes_weight_g"))
                // (if $tent_id == 14 then number_or_null(spec_value($tent_id; altaplex_key("stakes_weight_g"))) else null end)),
              weight_stuff_sack_g:
                (.weight_stuff_sack_g
                // number_or_null(spec_value($tent_id; "stuff_sack_weight_g"))
                // (if $tent_id == 14 then number_or_null(spec_value($tent_id; altaplex_key("stuff_sack_weight_g"))) else null end)),
              weight_repair_kit_g:
                (number_or_null(spec_value($tent_id; "repair_kit_weight_g"))
                // (if $tent_id == 14 then number_or_null(spec_value($tent_id; altaplex_key("repair_kit_weight_g"))) else null end)),
              weight_accessories_g:
                (number_or_null(spec_value($tent_id; "included_accessories_total_weight_g"))
                // number_or_null(spec_value($tent_id; "additional_items_total_weight_g"))
                // number_or_null(spec_value($tent_id; "additional_items_weight_g"))),
              weight_minimum_g:
                (number_or_null(spec_value($tent_id; "minimum_weight_g"))
                // number_or_null(spec_value($tent_id; "weight_minimum_g"))
                // (if $tent_id == 14 then number_or_null(spec_value($tent_id; altaplex_key("min_weight_g"))) else null end)),
              weight_packed_g:
                (number_or_null(spec_value($tent_id; "packed_weight_g"))
                // (if $tent_id == 14 then number_or_null(spec_value($tent_id; altaplex_key("packed_weight_g"))) else null end)),
              weight_poles_g:
                (.weight_poles_g
                // number_or_null(spec_value($tent_id; "carbon_poles_weight_g"))
                // number_or_null(spec_value($tent_id; "included_32_in_pole_weight_g"))),
              weight_scope_notes: spec_note($tent_id)
            }
          }
      )
    '
)

count=$(
  printf '%s' "$patches" | jq 'length'
)

while IFS= read -r patch_row; do
  row_id=$(printf '%s' "$patch_row" | jq -r '.id')
  payload=$(printf '%s' "$patch_row" | jq -c '.payload')

  /usr/bin/curl -s -X PATCH \
    -H "xc-token: $TOKEN" \
    -H "Content-Type: application/json" \
    "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$VARIANTS_TABLE_ID/$row_id" \
    --data "$payload" >/dev/null
done < <(printf '%s' "$patches" | jq -c '.[]')

echo "DONE patched=$count"
