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
TENTS_TABLE_ID="mhotmb11c4ge3mw"
VARIANTS_TABLE_ID="m1r4j89250jexvu"
SPECS_TABLE_ID="mumlsmxsho0do7w"

tent_id_from_slug() {
  local slug="$1"
  /usr/bin/curl -s -H "xc-token: $TOKEN" \
    "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$TENTS_TABLE_ID?where=(slug,eq,$slug)&limit=1" |
    jq -r '.list[0].Id // empty'
}

delete_weight_specs_for_tent() {
  local tent_id="$1"
  local ids

  ids=$(
    /usr/bin/curl -s -H "xc-token: $TOKEN" \
      "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$SPECS_TABLE_ID?where=(tent_id,eq,$tent_id)&limit=300" |
      jq -r '.list[] | select(.category=="poids") | .Id'
  )

  if [[ -z "$ids" ]]; then
    return
  fi

  while IFS= read -r id; do
    /usr/bin/curl -s -X DELETE \
      -H "xc-token: $TOKEN" \
      "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$SPECS_TABLE_ID/$id" >/dev/null
  done <<< "$ids"
}

insert_weight_specs_from_file() {
  local tent_id="$1"
  local file="$2"

  while IFS= read -r row; do
    payload=$(jq -cn --argjson tent_id "$tent_id" --argjson row "$row" '$row + {tent_id: $tent_id}')
    /usr/bin/curl -s -X POST \
      -H "xc-token: $TOKEN" \
      -H "Content-Type: application/json" \
      "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$SPECS_TABLE_ID" \
      --data "$payload" >/dev/null
  done < <(jq -c '.specs_extra[] | select(.category=="poids")' "$file")
}

sync_variant_weights_from_file() {
  local file="$1"

  jq -cn --slurpfile doc "$file" '
    def spec_value($key):
      ([ $doc[0].specs_extra[] | select(.category=="poids" and .key==$key) | .value ][0] // null);
    def spec_number($key):
      (spec_value($key) | if . == null then null elif test("^[0-9]+(\\.[0-9]+)?$") then tonumber else null end);
    def spec_text($keys):
      ([ $keys[] as $k | spec_value($k) | select(. != null and . != "") ][0] // null);

    $doc[0].variants[]
    | {
        variant_slug,
        payload: {
          weight_tent_g,
          weight_poles_g,
          weight_stakes_g: (if .weight_stakes_g != null then .weight_stakes_g else spec_number("stakes_weight_g") end),
          weight_stuff_sack_g: (if .weight_stuff_sack_g != null then .weight_stuff_sack_g else spec_number("stuff_sack_weight_g") end),
          weight_typical_g,
          weight_typical_notes,
          weight_displayed_g: .weight_tent_g,
          weight_body_g: spec_number("tent_body_weight_g"),
          weight_guy_lines_g: spec_number("guy_lines_weight_g"),
          weight_repair_kit_g: spec_number("repair_kit_weight_g"),
          weight_accessories_g: (
            spec_number("included_accessories_total_weight_g")
            // spec_number("additional_items_total_weight_g")
            // spec_number("additional_items_weight_g")
          ),
          weight_minimum_g: (
            spec_number("minimum_weight_g")
            // spec_number("weight_minimum_g")
          ),
          weight_packed_g: spec_number("packed_weight_g"),
          weight_scope_notes: spec_text([
            "displayed_weight_scope",
            "product_weight_display_scope",
            "weight_scope_note",
            "weight_variation_note",
            "weight_display_scope"
          ])
        }
      }
  ' | while IFS= read -r row; do
    variant_slug=$(printf '%s' "$row" | jq -r '.variant_slug')
    variant_id=$(
      /usr/bin/curl -s -H "xc-token: $TOKEN" \
        "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$VARIANTS_TABLE_ID?where=(variant_slug,eq,$variant_slug)&limit=1" |
        jq -r '.list[0].Id // empty'
    )

    if [[ -z "$variant_id" ]]; then
      continue
    fi

    payload=$(printf '%s' "$row" | jq -c '.payload')

    /usr/bin/curl -s -X PATCH \
      -H "xc-token: $TOKEN" \
      -H "Content-Type: application/json" \
      "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$VARIANTS_TABLE_ID/$variant_id" \
      --data "$payload" >/dev/null
  done
}

for file in raw_data/zpacks/*.json; do
  slug=$(jq -r '.tent.slug' "$file")
  tent_id=$(tent_id_from_slug "$slug")

  if [[ -z "$tent_id" ]]; then
    continue
  fi

  delete_weight_specs_for_tent "$tent_id"
  insert_weight_specs_from_file "$tent_id" "$file"
  sync_variant_weights_from_file "$file"

  echo "SYNCED $slug"
done
