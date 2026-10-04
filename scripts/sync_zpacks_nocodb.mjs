import fs from "fs";
import path from "path";
import { fileURLToPath } from "node:url";

const ROOT = fileURLToPath(new URL("../", import.meta.url));
const ENV_PATH = path.join(ROOT, ".env");
const ZPACKS_DIR = path.join(ROOT, "raw_data", "zpacks");

const TENTS_TABLE = "mhotmb11c4ge3mw";
const VARIANTS_TABLE = "m1r4j89250jexvu";
const SPECS_TABLE = "mumlsmxsho0do7w";

function readEnv(filePath) {
  const env = {};
  const raw = fs.readFileSync(filePath, "utf8");
  for (const line of raw.split("\n")) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) continue;
    const eq = trimmed.indexOf("=");
    if (eq === -1) continue;
    env[trimmed.slice(0, eq)] = trimmed.slice(eq + 1);
  }
  return env;
}

const env = readEnv(ENV_PATH);
const BASE_URL = `${env.NOCODB_BASE_URL}/api/v1/db/data/noco/${env.NOCODB_BASE_ID}`;
const TOKEN = env.NOCODB_API_TOKEN;

async function nocoFetch(endpoint, options = {}) {
  const res = await fetch(`${BASE_URL}/${endpoint}`, {
    ...options,
    headers: {
      "xc-token": TOKEN,
      "Content-Type": "application/json",
      ...(options.headers || {}),
    },
  });

  const text = await res.text();
  let json = null;
  try {
    json = text ? JSON.parse(text) : null;
  } catch {
    json = text;
  }

  if (!res.ok) {
    throw new Error(`${options.method || "GET"} ${endpoint} failed: ${res.status} ${JSON.stringify(json)}`);
  }

  return json;
}

const TENT_FIELDS = [
  "name",
  "slug",
  "tagline",
  "description",
  "key_features",
  "manufacturer_claims",
  "ideal_for",
  "comparison_notes",
  "care_instructions",
  "repair_notes",
  "faq_important",
  "compatible_accessories",
  "warranty_notes",
  "capacity",
  "season_rating",
  "structure_type",
  "wall_type",
  "poles_required",
  "poles_included",
  "geometry_name",
  "geometry_patented",
  "door_count",
  "vestibule_count",
  "vent_count",
  "interior_pockets",
  "guy_lines_max",
  "stake_points_max",
  "floor_length_cm",
  "floor_width_cm",
  "floor_width_head_cm",
  "floor_width_foot_cm",
  "floor_area_sqm",
  "floor_bathtub_height_cm",
  "floor_height_adjustable",
  "peak_height_inner_cm",
  "peak_height_fly_cm",
  "vestibule_area_sqm",
  "vestibule_depth_cm",
  "fly_length_cm",
  "fly_width_cm",
  "fly_fabric",
  "fly_fabric_type",
  "fly_waterproofness_mm",
  "fly_pfas_free",
  "floor_fabric",
  "floor_fabric_type",
  "floor_waterproofness_mm",
  "inner_fabric",
  "inner_mesh",
  "seam_construction",
  "seam_waterproof",
  "zipper_fly",
  "zipper_inner",
  "magnetic_toggles",
  "pole_diameter_mm",
  "pole_sleeve_material",
  "pole_splint_included",
  "pole_jack_included",
  "tie_out_count_perimeter",
  "tie_out_count_midpanel",
  "tie_out_count_apex",
  "ladder_locks",
  "guyline_brand",
  "fly_first_pitch",
  "inner_first_pitch",
  "freestanding_no_stakes",
  "protected_doorways",
  "full_coverage_fly",
  "tensioned_floor",
  "groundsheet_required",
  "groundsheet_recommended",
  "trekking_pole_support",
  "vestibule_pole_support",
  "reflective_elements",
  "manufacture_country",
  "stakes_included",
  "stakes_type",
  "stuff_sack_included",
  "repair_kit_included",
  "carry_bag_included",
  "price_usd",
  "price_eur",
  "product_url",
  "warranty_years",
];

const VARIANT_FIELDS = [
  "variant_name",
  "variant_slug",
  "pole_option",
  "floor_option",
  "inner_option",
  "color",
  "weight_tent_g",
  "weight_fly_g",
  "weight_inner_g",
  "weight_poles_g",
  "weight_stakes_g",
  "weight_stuff_sack_g",
  "weight_typical_g",
  "weight_typical_notes",
  "packed_length_cm",
  "packed_diameter_cm",
  "price_usd",
  "price_eur",
  "in_stock",
];

function pick(source, keys) {
  const out = {};
  for (const key of keys) {
    out[key] = Object.prototype.hasOwnProperty.call(source, key) ? source[key] : null;
  }
  return out;
}

async function syncOne(jsonPath) {
  const data = JSON.parse(fs.readFileSync(jsonPath, "utf8"));
  const slug = data.tent.slug;
  const tentLookup = await nocoFetch(`${TENTS_TABLE}?where=(slug,eq,${slug})&limit=1`);
  const row = tentLookup.list?.[0];

  if (!row) {
    throw new Error(`Tent not found in NocoDB for slug ${slug}`);
  }

  const tentPayload = {
    brand_id: row.brand_id,
    ...pick(data.tent, TENT_FIELDS),
  };

  await nocoFetch(`${TENTS_TABLE}/${row.Id}`, {
    method: "PATCH",
    body: JSON.stringify(tentPayload),
  });

  const existingVariants = await nocoFetch(`${VARIANTS_TABLE}?where=(tent_id,eq,${row.Id})&limit=200`);
  for (const variant of existingVariants.list || []) {
    await nocoFetch(`${VARIANTS_TABLE}/${variant.Id}`, { method: "DELETE" });
  }

  for (const variant of data.variants || []) {
    const payload = {
      tent_id: row.Id,
      ...pick(variant, VARIANT_FIELDS),
    };
    await nocoFetch(VARIANTS_TABLE, {
      method: "POST",
      body: JSON.stringify(payload),
    });
  }

  const existingSpecs = await nocoFetch(`${SPECS_TABLE}?where=(tent_id,eq,${row.Id})&limit=500`);
  for (const spec of existingSpecs.list || []) {
    await nocoFetch(`${SPECS_TABLE}/${spec.Id}`, { method: "DELETE" });
  }

  for (const spec of data.specs_extra || []) {
    const payload = {
      tent_id: row.Id,
      key: spec.key,
      value: spec.value,
      unit: spec.unit,
      label: spec.label,
      category: spec.category,
    };
    await nocoFetch(SPECS_TABLE, {
      method: "POST",
      body: JSON.stringify(payload),
    });
  }

  return {
    slug,
    tentId: row.Id,
    variants: (data.variants || []).length,
    specs: (data.specs_extra || []).length,
  };
}

async function main() {
  const requestedSlugs = new Set(process.argv.slice(2));
  const files = fs
    .readdirSync(ZPACKS_DIR)
    .filter((file) => file.endsWith(".json"))
    .filter((file) => requestedSlugs.size === 0 || requestedSlugs.has(file.replace(/\.json$/, "")))
    .sort()
    .map((file) => path.join(ZPACKS_DIR, file));

  const results = [];
  for (const file of files) {
    results.push(await syncOne(file));
  }

  console.log(JSON.stringify(results, null, 2));
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
