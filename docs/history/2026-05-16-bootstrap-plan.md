# MatosTrek — Full Project Bootstrap Plan

> Copie publique anonymisée : le chemin local du propriétaire et l'identifiant de sa base NocoDB ont été remplacés par des exemples. Le plan et sa date documentaire sont conservés.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bootstrap the full MatosTrek stack from zero — Next.js 15 frontend, NocoDB schema, MCP wiring, folder structure, CLAUDE.md rules, and tent page template.

**Architecture:** NocoDB (localhost:8080) is the single source of truth. Data flows: web URL → JSON (raw_data/) → NocoDB via MCP → Next.js pages via NocoDB REST API. MDX files in content/tents/ are generated from DB, never hand-edited.

**Tech Stack:** Next.js 15 (App Router), TypeScript, Tailwind CSS v4, NocoDB v2 REST API, nocodb-mcp-server

**NocoDB config:**
- Base URL: `http://localhost:8080`
- Base ID: `EXAMPLE_BASE_ID`
- API Token: read from `NOCODB_API_TOKEN` env var

---

## File Map

```
matostrek/
├── .env                                  ← secrets (gitignored)
├── .env.example                          ← template committed
├── .mcp.json                             ← MCP server config
├── .gitignore
├── CLAUDE.md                             ← agent rules (permanent)
├── package.json
├── tsconfig.json
├── next.config.ts
├── tailwind.config.ts
├── postcss.config.mjs
├── schema.sql                            ← reference schema
├── raw_data/                             ← source JSONs (never edit after import)
├── templates/
│   └── tent-page.template.mdx            ← display template
├── content/
│   └── tents/                            ← generated MDX (from DB)
├── src/
│   ├── app/
│   │   ├── layout.tsx                    ← root layout + nav
│   │   ├── page.tsx                      ← homepage
│   │   └── tentes/
│   │       ├── page.tsx                  ← tent listing
│   │       └── [slug]/
│   │           └── page.tsx             ← tent detail page
│   ├── lib/
│   │   └── nocodb.ts                     ← NocoDB REST client
│   └── types/
│       └── tent.ts                       ← TypeScript types
└── docs/superpowers/plans/
    └── 2026-05-16-matostrek-init.md
```

---

## Task 1: Project Scaffold (Next.js 15 + Tailwind)

**Files:**
- Create: `package.json`, `tsconfig.json`, `next.config.ts`, `tailwind.config.ts`, `postcss.config.mjs`
- Create: `.gitignore`, `.env.example`

- [ ] **Step 1: Init Next.js 15 app**

```bash
cd /path/to/matostrek
npx create-next-app@latest . \
  --typescript \
  --tailwind \
  --app \
  --src-dir \
  --no-git \
  --import-alias "@/*" \
  --eslint
```

Expected: project files created, `node_modules/` installed.

- [ ] **Step 2: Create .gitignore**

```
node_modules/
.next/
.env
.env.local
raw_data/
```

(raw_data gitignored — contains scraped data, not source code)

- [ ] **Step 3: Create .env.example**

```bash
cat > .env.example << 'EOF'
NOCODB_BASE_URL=http://localhost:8080
NOCODB_BASE_ID=EXAMPLE_BASE_ID
NOCODB_API_TOKEN=your_token_here
EOF
```

- [ ] **Step 4: Create .env (user fills token)**

```bash
cp .env.example .env
```

User must replace `your_token_here` with real token from NocoDB → Settings → API Tokens.

- [ ] **Step 5: Create folder structure**

```bash
mkdir -p raw_data templates content/tents src/lib src/types
```

- [ ] **Step 6: Verify dev server starts**

```bash
npm run dev
```

Expected: `http://localhost:3000` responds with Next.js default page.

- [ ] **Step 7: Commit**

```bash
git init
git add -A
git commit -m "feat: init Next.js 15 + Tailwind project scaffold"
```

---

## Task 2: TypeScript Types

**Files:**
- Create: `src/types/tent.ts`

- [ ] **Step 1: Write tent types**

```typescript
// src/types/tent.ts
export interface Brand {
  id: number
  name: string
  slug: string
  country: string | null
  website_url: string
}

export interface Tent {
  id: number
  brand_id: number
  name: string
  slug: string
  tagline: string | null
  description: string | null
  key_features: string | null
  manufacturer_claims: string | null
  ideal_for: string | null
  comparison_notes: string | null
  care_instructions: string | null
  repair_notes: string | null
  faq_important: string | null
  compatible_accessories: string | null
  warranty_notes: string | null
  capacity: number | null
  season_rating: '3-season' | '4-season' | '3-4-season' | null
  structure_type: 'freestanding' | 'semi-freestanding' | 'non-freestanding' | null
  wall_type: 'double' | 'single' | 'hybrid' | null
  poles_required: 'trekking' | 'dedicated' | 'none' | null
  poles_included: boolean | null
  geometry_name: string | null
  geometry_patented: boolean | null
  door_count: number | null
  vestibule_count: number | null
  vent_count: number | null
  interior_pockets: number | null
  guy_lines_max: number | null
  stake_points_max: number | null
  floor_length_cm: number | null
  floor_width_cm: number | null
  floor_width_head_cm: number | null
  floor_width_foot_cm: number | null
  floor_area_sqm: number | null
  floor_bathtub_height_cm: number | null
  floor_height_adjustable: boolean | null
  peak_height_inner_cm: number | null
  peak_height_fly_cm: number | null
  vestibule_area_sqm: number | null
  vestibule_depth_cm: number | null
  fly_length_cm: number | null
  fly_width_cm: number | null
  fly_fabric: string | null
  fly_fabric_type: 'polyester' | 'nylon' | 'DCF' | 'silpoly' | 'silnylon' | null
  fly_waterproofness_mm: number | null
  fly_pfas_free: boolean | null
  floor_fabric: string | null
  floor_fabric_type: 'polyester' | 'nylon' | 'DCF' | 'silpoly' | 'silnylon' | null
  floor_waterproofness_mm: number | null
  inner_fabric: string | null
  inner_mesh: boolean | null
  seam_construction: 'taped' | 'hot-bonded' | 'none' | null
  seam_waterproof: boolean | null
  zipper_fly: string | null
  zipper_inner: string | null
  magnetic_toggles: boolean | null
  pole_diameter_mm: number | null
  pole_sleeve_material: string | null
  pole_splint_included: boolean | null
  pole_jack_included: boolean | null
  tie_out_count_perimeter: number | null
  tie_out_count_midpanel: number | null
  tie_out_count_apex: number | null
  ladder_locks: boolean | null
  guyline_brand: string | null
  fly_first_pitch: boolean | null
  inner_first_pitch: boolean | null
  freestanding_no_stakes: boolean | null
  protected_doorways: boolean | null
  full_coverage_fly: boolean | null
  tensioned_floor: boolean | null
  groundsheet_required: boolean | null
  groundsheet_recommended: boolean | null
  trekking_pole_support: boolean | null
  vestibule_pole_support: boolean | null
  reflective_elements: boolean | null
  manufacture_country: string | null
  stakes_included: number | null
  stakes_type: string | null
  stuff_sack_included: boolean | null
  repair_kit_included: boolean | null
  carry_bag_included: boolean | null
  price_usd: number | null
  price_eur: number | null
  product_url: string
  warranty_years: number | null
}

export interface TentVariant {
  id: number
  tent_id: number
  variant_name: string
  variant_slug: string
  pole_option: string | null
  floor_option: string | null
  inner_option: string | null
  color: string | null
  weight_tent_g: number | null
  weight_fly_g: number | null
  weight_inner_g: number | null
  weight_poles_g: number | null
  weight_stakes_g: number | null
  weight_stuff_sack_g: number | null
  weight_typical_g: number | null
  weight_typical_notes: string | null
  packed_length_cm: number | null
  packed_diameter_cm: number | null
  price_usd: number | null
  price_eur: number | null
  in_stock: boolean | null
}

export interface TentSpecExtra {
  id: number
  tent_id: number
  key: string
  value: string
  unit: string | null
  label: string
  category: string
}
```

- [ ] **Step 2: Commit**

```bash
git add src/types/tent.ts
git commit -m "feat: add TypeScript types for tents, variants, specs"
```

---

## Task 3: NocoDB REST Client

**Files:**
- Create: `src/lib/nocodb.ts`

- [ ] **Step 1: Write NocoDB client**

```typescript
// src/lib/nocodb.ts
const BASE_URL = process.env.NOCODB_BASE_URL!
const BASE_ID = process.env.NOCODB_BASE_ID!
const TOKEN = process.env.NOCODB_API_TOKEN!

async function nocoFetch(path: string, options: RequestInit = {}) {
  const res = await fetch(`${BASE_URL}/api/v1${path}`, {
    ...options,
    headers: {
      'xc-token': TOKEN,
      'Content-Type': 'application/json',
      ...options.headers,
    },
    cache: 'no-store',
  })
  if (!res.ok) throw new Error(`NocoDB ${res.status}: ${await res.text()}`)
  return res.json()
}

export async function listTents(): Promise<{ list: any[] }> {
  return nocoFetch(`/db/data/noco/${BASE_ID}/tents?limit=100`)
}

export async function getTentBySlug(slug: string): Promise<any | null> {
  const data = await nocoFetch(
    `/db/data/noco/${BASE_ID}/tents?where=(slug,eq,${slug})&limit=1`
  )
  return data.list?.[0] ?? null
}

export async function getTentVariants(tentId: number): Promise<any[]> {
  const data = await nocoFetch(
    `/db/data/noco/${BASE_ID}/tent_variants?where=(tent_id,eq,${tentId})&limit=50`
  )
  return data.list ?? []
}

export async function getTentSpecsExtra(tentId: number): Promise<any[]> {
  const data = await nocoFetch(
    `/db/data/noco/${BASE_ID}/tent_specs_extra?where=(tent_id,eq,${tentId})&limit=100`
  )
  return data.list ?? []
}

export async function getBrandById(brandId: number): Promise<any | null> {
  const data = await nocoFetch(
    `/db/data/noco/${BASE_ID}/brands?where=(Id,eq,${brandId})&limit=1`
  )
  return data.list?.[0] ?? null
}
```

- [ ] **Step 2: Commit**

```bash
git add src/lib/nocodb.ts
git commit -m "feat: NocoDB REST client with tent/brand/variant queries"
```

---

## Task 4: NocoDB Schema — Create Tables via API

**Files:**
- Create: `schema.sql` (reference only)
- Script runs: NocoDB REST API calls to create tables

The NocoDB API token must be in `.env` before running these steps.

- [ ] **Step 1: Create `brands` table**

```bash
source .env
curl -s -X POST "http://localhost:8080/api/v1/db/meta/projects/${NOCODB_BASE_ID}/tables" \
  -H "xc-token: ${NOCODB_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "brands",
    "columns": [
      {"title": "name", "uidt": "SingleLineText"},
      {"title": "slug", "uidt": "SingleLineText"},
      {"title": "country", "uidt": "SingleLineText"},
      {"title": "website_url", "uidt": "URL"}
    ]
  }' | jq '.id'
```

Expected: prints the new table ID.

- [ ] **Step 2: Create `tents` table**

```bash
source .env
curl -s -X POST "http://localhost:8080/api/v1/db/meta/projects/${NOCODB_BASE_ID}/tables" \
  -H "xc-token: ${NOCODB_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "tents",
    "columns": [
      {"title": "brand_id", "uidt": "Number"},
      {"title": "name", "uidt": "SingleLineText"},
      {"title": "slug", "uidt": "SingleLineText"},
      {"title": "tagline", "uidt": "SingleLineText"},
      {"title": "description", "uidt": "LongText"},
      {"title": "key_features", "uidt": "LongText"},
      {"title": "manufacturer_claims", "uidt": "LongText"},
      {"title": "ideal_for", "uidt": "LongText"},
      {"title": "comparison_notes", "uidt": "LongText"},
      {"title": "care_instructions", "uidt": "LongText"},
      {"title": "repair_notes", "uidt": "LongText"},
      {"title": "faq_important", "uidt": "LongText"},
      {"title": "compatible_accessories", "uidt": "LongText"},
      {"title": "warranty_notes", "uidt": "LongText"},
      {"title": "capacity", "uidt": "Number"},
      {"title": "season_rating", "uidt": "SingleLineText"},
      {"title": "structure_type", "uidt": "SingleLineText"},
      {"title": "wall_type", "uidt": "SingleLineText"},
      {"title": "poles_required", "uidt": "SingleLineText"},
      {"title": "poles_included", "uidt": "Checkbox"},
      {"title": "geometry_name", "uidt": "SingleLineText"},
      {"title": "geometry_patented", "uidt": "Checkbox"},
      {"title": "door_count", "uidt": "Number"},
      {"title": "vestibule_count", "uidt": "Number"},
      {"title": "vent_count", "uidt": "Number"},
      {"title": "interior_pockets", "uidt": "Number"},
      {"title": "guy_lines_max", "uidt": "Number"},
      {"title": "stake_points_max", "uidt": "Number"},
      {"title": "floor_length_cm", "uidt": "Decimal"},
      {"title": "floor_width_cm", "uidt": "Decimal"},
      {"title": "floor_width_head_cm", "uidt": "Decimal"},
      {"title": "floor_width_foot_cm", "uidt": "Decimal"},
      {"title": "floor_area_sqm", "uidt": "Decimal"},
      {"title": "floor_bathtub_height_cm", "uidt": "Decimal"},
      {"title": "floor_height_adjustable", "uidt": "Checkbox"},
      {"title": "peak_height_inner_cm", "uidt": "Decimal"},
      {"title": "peak_height_fly_cm", "uidt": "Decimal"},
      {"title": "vestibule_area_sqm", "uidt": "Decimal"},
      {"title": "vestibule_depth_cm", "uidt": "Decimal"},
      {"title": "fly_length_cm", "uidt": "Decimal"},
      {"title": "fly_width_cm", "uidt": "Decimal"},
      {"title": "fly_fabric", "uidt": "SingleLineText"},
      {"title": "fly_fabric_type", "uidt": "SingleLineText"},
      {"title": "fly_waterproofness_mm", "uidt": "Number"},
      {"title": "fly_pfas_free", "uidt": "Checkbox"},
      {"title": "floor_fabric", "uidt": "SingleLineText"},
      {"title": "floor_fabric_type", "uidt": "SingleLineText"},
      {"title": "floor_waterproofness_mm", "uidt": "Number"},
      {"title": "inner_fabric", "uidt": "SingleLineText"},
      {"title": "inner_mesh", "uidt": "Checkbox"},
      {"title": "seam_construction", "uidt": "SingleLineText"},
      {"title": "seam_waterproof", "uidt": "Checkbox"},
      {"title": "zipper_fly", "uidt": "SingleLineText"},
      {"title": "zipper_inner", "uidt": "SingleLineText"},
      {"title": "magnetic_toggles", "uidt": "Checkbox"},
      {"title": "pole_diameter_mm", "uidt": "Decimal"},
      {"title": "pole_sleeve_material", "uidt": "SingleLineText"},
      {"title": "pole_splint_included", "uidt": "Checkbox"},
      {"title": "pole_jack_included", "uidt": "Checkbox"},
      {"title": "tie_out_count_perimeter", "uidt": "Number"},
      {"title": "tie_out_count_midpanel", "uidt": "Number"},
      {"title": "tie_out_count_apex", "uidt": "Number"},
      {"title": "ladder_locks", "uidt": "Checkbox"},
      {"title": "guyline_brand", "uidt": "SingleLineText"},
      {"title": "fly_first_pitch", "uidt": "Checkbox"},
      {"title": "inner_first_pitch", "uidt": "Checkbox"},
      {"title": "freestanding_no_stakes", "uidt": "Checkbox"},
      {"title": "protected_doorways", "uidt": "Checkbox"},
      {"title": "full_coverage_fly", "uidt": "Checkbox"},
      {"title": "tensioned_floor", "uidt": "Checkbox"},
      {"title": "groundsheet_required", "uidt": "Checkbox"},
      {"title": "groundsheet_recommended", "uidt": "Checkbox"},
      {"title": "trekking_pole_support", "uidt": "Checkbox"},
      {"title": "vestibule_pole_support", "uidt": "Checkbox"},
      {"title": "reflective_elements", "uidt": "Checkbox"},
      {"title": "manufacture_country", "uidt": "SingleLineText"},
      {"title": "stakes_included", "uidt": "Number"},
      {"title": "stakes_type", "uidt": "SingleLineText"},
      {"title": "stuff_sack_included", "uidt": "Checkbox"},
      {"title": "repair_kit_included", "uidt": "Checkbox"},
      {"title": "carry_bag_included", "uidt": "Checkbox"},
      {"title": "price_usd", "uidt": "Decimal"},
      {"title": "price_eur", "uidt": "Decimal"},
      {"title": "product_url", "uidt": "URL"},
      {"title": "warranty_years", "uidt": "Number"}
    ]
  }' | jq '.id'
```

- [ ] **Step 3: Create `tent_variants` table**

```bash
source .env
curl -s -X POST "http://localhost:8080/api/v1/db/meta/projects/${NOCODB_BASE_ID}/tables" \
  -H "xc-token: ${NOCODB_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "tent_variants",
    "columns": [
      {"title": "tent_id", "uidt": "Number"},
      {"title": "variant_name", "uidt": "SingleLineText"},
      {"title": "variant_slug", "uidt": "SingleLineText"},
      {"title": "pole_option", "uidt": "SingleLineText"},
      {"title": "floor_option", "uidt": "SingleLineText"},
      {"title": "inner_option", "uidt": "SingleLineText"},
      {"title": "color", "uidt": "SingleLineText"},
      {"title": "weight_tent_g", "uidt": "Decimal"},
      {"title": "weight_fly_g", "uidt": "Decimal"},
      {"title": "weight_inner_g", "uidt": "Decimal"},
      {"title": "weight_poles_g", "uidt": "Decimal"},
      {"title": "weight_stakes_g", "uidt": "Decimal"},
      {"title": "weight_stuff_sack_g", "uidt": "Decimal"},
      {"title": "weight_typical_g", "uidt": "Decimal"},
      {"title": "weight_typical_notes", "uidt": "LongText"},
      {"title": "packed_length_cm", "uidt": "Decimal"},
      {"title": "packed_diameter_cm", "uidt": "Decimal"},
      {"title": "price_usd", "uidt": "Decimal"},
      {"title": "price_eur", "uidt": "Decimal"},
      {"title": "in_stock", "uidt": "Checkbox"}
    ]
  }' | jq '.id'
```

- [ ] **Step 4: Create `tent_specs_extra` table**

```bash
source .env
curl -s -X POST "http://localhost:8080/api/v1/db/meta/projects/${NOCODB_BASE_ID}/tables" \
  -H "xc-token: ${NOCODB_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "tent_specs_extra",
    "columns": [
      {"title": "tent_id", "uidt": "Number"},
      {"title": "key", "uidt": "SingleLineText"},
      {"title": "value", "uidt": "LongText"},
      {"title": "unit", "uidt": "SingleLineText"},
      {"title": "label", "uidt": "SingleLineText"},
      {"title": "category", "uidt": "SingleLineText"}
    ]
  }' | jq '.id'
```

- [ ] **Step 5: Verify tables visible in NocoDB UI**

Open `http://localhost:8080` → confirm 4 tables exist: `brands`, `tents`, `tent_variants`, `tent_specs_extra`.

- [ ] **Step 6: Write schema.sql reference**

```bash
cat > schema.sql << 'EOF'
-- Reference schema (NocoDB is source of truth — this is documentation only)

CREATE TABLE brands (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  country TEXT,
  website_url TEXT
);

CREATE TABLE tents (
  id SERIAL PRIMARY KEY,
  brand_id INTEGER REFERENCES brands(id),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  tagline TEXT,
  description TEXT,
  key_features TEXT,
  manufacturer_claims TEXT,
  ideal_for TEXT,
  comparison_notes TEXT,
  care_instructions TEXT,
  repair_notes TEXT,
  faq_important TEXT,
  compatible_accessories TEXT,
  warranty_notes TEXT,
  capacity INTEGER,
  season_rating TEXT,
  structure_type TEXT,
  wall_type TEXT,
  poles_required TEXT,
  poles_included BOOLEAN,
  geometry_name TEXT,
  geometry_patented BOOLEAN,
  door_count INTEGER,
  vestibule_count INTEGER,
  vent_count INTEGER,
  interior_pockets INTEGER,
  guy_lines_max INTEGER,
  stake_points_max INTEGER,
  floor_length_cm DECIMAL,
  floor_width_cm DECIMAL,
  floor_width_head_cm DECIMAL,
  floor_width_foot_cm DECIMAL,
  floor_area_sqm DECIMAL,
  floor_bathtub_height_cm DECIMAL,
  floor_height_adjustable BOOLEAN,
  peak_height_inner_cm DECIMAL,
  peak_height_fly_cm DECIMAL,
  vestibule_area_sqm DECIMAL,
  vestibule_depth_cm DECIMAL,
  fly_length_cm DECIMAL,
  fly_width_cm DECIMAL,
  fly_fabric TEXT,
  fly_fabric_type TEXT,
  fly_waterproofness_mm INTEGER,
  fly_pfas_free BOOLEAN,
  floor_fabric TEXT,
  floor_fabric_type TEXT,
  floor_waterproofness_mm INTEGER,
  inner_fabric TEXT,
  inner_mesh BOOLEAN,
  seam_construction TEXT,
  seam_waterproof BOOLEAN,
  zipper_fly TEXT,
  zipper_inner TEXT,
  magnetic_toggles BOOLEAN,
  pole_diameter_mm DECIMAL,
  pole_sleeve_material TEXT,
  pole_splint_included BOOLEAN,
  pole_jack_included BOOLEAN,
  tie_out_count_perimeter INTEGER,
  tie_out_count_midpanel INTEGER,
  tie_out_count_apex INTEGER,
  ladder_locks BOOLEAN,
  guyline_brand TEXT,
  fly_first_pitch BOOLEAN,
  inner_first_pitch BOOLEAN,
  freestanding_no_stakes BOOLEAN,
  protected_doorways BOOLEAN,
  full_coverage_fly BOOLEAN,
  tensioned_floor BOOLEAN,
  groundsheet_required BOOLEAN,
  groundsheet_recommended BOOLEAN,
  trekking_pole_support BOOLEAN,
  vestibule_pole_support BOOLEAN,
  reflective_elements BOOLEAN,
  manufacture_country TEXT,
  stakes_included INTEGER,
  stakes_type TEXT,
  stuff_sack_included BOOLEAN,
  repair_kit_included BOOLEAN,
  carry_bag_included BOOLEAN,
  price_usd DECIMAL,
  price_eur DECIMAL,
  product_url TEXT NOT NULL,
  warranty_years INTEGER
);

CREATE TABLE tent_variants (
  id SERIAL PRIMARY KEY,
  tent_id INTEGER REFERENCES tents(id),
  variant_name TEXT NOT NULL,
  variant_slug TEXT NOT NULL,
  pole_option TEXT,
  floor_option TEXT,
  inner_option TEXT,
  color TEXT,
  weight_tent_g DECIMAL,
  weight_fly_g DECIMAL,
  weight_inner_g DECIMAL,
  weight_poles_g DECIMAL,
  weight_stakes_g DECIMAL,
  weight_stuff_sack_g DECIMAL,
  weight_typical_g DECIMAL,
  weight_typical_notes TEXT,
  packed_length_cm DECIMAL,
  packed_diameter_cm DECIMAL,
  price_usd DECIMAL,
  price_eur DECIMAL,
  in_stock BOOLEAN
);

CREATE TABLE tent_specs_extra (
  id SERIAL PRIMARY KEY,
  tent_id INTEGER REFERENCES tents(id),
  key TEXT NOT NULL,
  value TEXT NOT NULL,
  unit TEXT,
  label TEXT NOT NULL,
  category TEXT NOT NULL
);
EOF
```

- [ ] **Step 7: Commit**

```bash
git add schema.sql
git commit -m "feat: NocoDB schema created — brands, tents, tent_variants, tent_specs_extra"
```

---

## Task 5: MCP Configuration

**Files:**
- Create: `.mcp.json`

- [ ] **Step 1: Create .mcp.json**

```json
{
  "mcpServers": {
    "nocodb": {
      "command": "npx",
      "args": [
        "-y",
        "nocodb-mcp-server",
        "http://localhost:8080",
        "EXAMPLE_BASE_ID",
        "${NOCODB_API_TOKEN}"
      ]
    }
  }
}
```

**Note:** `${NOCODB_API_TOKEN}` is resolved from shell env. Make sure `.env` is sourced or token exported before starting Claude Code.

- [ ] **Step 2: Test MCP connection**

In Claude Code, run:
```
/mcp
```
Expected: `nocodb` server listed as connected.

- [ ] **Step 3: Commit**

```bash
git add .mcp.json
git commit -m "feat: MCP config for NocoDB"
```

---

## Task 6: CLAUDE.md (Agent Rules)

**Files:**
- Create: `CLAUDE.md`

- [ ] **Step 1: Create CLAUDE.md**

```markdown
# MatosTrek — Agent Rules

## Role
DB agent for MatosTrek ultralight gear site. When user gives URLs or products → extract → import → confirm.

## Always On
1. Fetch every URL given
2. Extract ALL data (specs + all informative text)
3. Map to NocoDB schema
4. Create missing columns before INSERT
5. INSERT or UPDATE (deduplicate by slug)
6. Confirm with summary

## Zero Invention
- Numeric data absent from page → `null`
- Text → summarize OK, flag as summary
- No estimates, no calculations, no interpolation

## Units
- Weight: grams only (display converts to oz ÷ 28.3495)
- Dimensions: cm only (display converts to inches ÷ 2.54)

## Deduplication
- Primary key: `slug`
- Exists → UPDATE
- Missing → INSERT
- Never create duplicates

## File Locations
- Raw data: `raw_data/<brand_slug>/<tent_slug>.json`
- Content: `content/tents/<slug>.mdx` (generated, never hand-edited)
- Templates: `templates/tent-page.template.mdx`

## NocoDB
- Base URL: http://localhost:8080
- Base ID: EXAMPLE_BASE_ID
- Token: from NOCODB_API_TOKEN env var
- MCP server: nocodb (configured in .mcp.json)

## Enum Values
- structure_type: freestanding | semi-freestanding | non-freestanding
- wall_type: double | single | hybrid
- poles_required: trekking | dedicated | none
- season_rating: 3-season | 4-season | 3-4-season
- fly_fabric_type / floor_fabric_type: polyester | nylon | DCF | silpoly | silnylon
- seam_construction: taped | hot-bonded | none
```

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "feat: CLAUDE.md agent rules"
```

---

## Task 7: Tent Page Template

**Files:**
- Create: `templates/tent-page.template.mdx`

- [ ] **Step 1: Write tent template**

```mdx
---
# tent-page.template.mdx
# Sections marked [OPTIONAL] → skip entire block if value is null
---

# {{tent.name}}

{{#if tent.tagline}}
> {{tent.tagline}}
{{/if}}

## Résumé

{{#if tent.description}}
{{tent.description}}
{{/if}}

## Specs clés

| | |
|---|---|
| Capacité | {{tent.capacity}} personne{{#if (gt tent.capacity 1)}}s{{/if}} |
| Saison | {{tent.season_rating}} |
| Structure | {{tent.structure_type}} |
| Double toit | {{#if (eq tent.wall_type "double")}}Oui{{else}}Non{{/if}} |
{{#if tent.door_count}}| Portes | {{tent.door_count}} |{{/if}}
{{#if tent.vestibule_count}}| Absides | {{tent.vestibule_count}} |{{/if}}

## Dimensions

{{#if tent.floor_length_cm}}
- **Sol** : {{tent.floor_length_cm}}cm × {{tent.floor_width_cm}}cm ({{divide tent.floor_length_cm 2.54 1}}" × {{divide tent.floor_width_cm 2.54 1}}")
{{/if}}
{{#if tent.floor_area_sqm}}
- **Surface intérieure** : {{tent.floor_area_sqm}} m²
{{/if}}
{{#if tent.peak_height_inner_cm}}
- **Hauteur** : {{tent.peak_height_inner_cm}}cm ({{divide tent.peak_height_inner_cm 2.54 1}}")
{{/if}}

## Poids — Variantes

{{#each variants}}
### {{this.variant_name}}

{{#if this.weight_tent_g}}
- **Poids complet** : {{this.weight_tent_g}}g / {{divide this.weight_tent_g 28.3495 1}}oz
{{/if}}
{{#if this.weight_typical_g}}
- **Poids typique** : {{this.weight_typical_g}}g / {{divide this.weight_typical_g 28.3495 1}}oz{{#if this.weight_typical_notes}} ({{this.weight_typical_notes}}){{/if}}
{{/if}}
{{#if this.packed_length_cm}}
- **Emballé** : {{this.packed_length_cm}}cm × ⌀{{this.packed_diameter_cm}}cm
{{/if}}
{{#if this.price_eur}}
- **Prix** : {{this.price_eur}} €
{{/if}}
{{/each}}

## Matériaux

{{#if tent.fly_fabric}}
- **Double toit** : {{tent.fly_fabric}}{{#if tent.fly_waterproofness_mm}} — {{tent.fly_waterproofness_mm}}mm{{/if}}
{{/if}}
{{#if tent.floor_fabric}}
- **Plancher** : {{tent.floor_fabric}}{{#if tent.floor_waterproofness_mm}} — {{tent.floor_waterproofness_mm}}mm{{/if}}
{{/if}}
{{#if tent.inner_fabric}}
- **Intérieur** : {{tent.inner_fabric}}
{{/if}}
{{#if tent.seam_construction}}
- **Coutures** : {{tent.seam_construction}}
{{/if}}

{{#if tent.key_features}}
## Points forts

{{tent.key_features}}
{{/if}}

{{#if tent.ideal_for}}
## Pour qui ?

{{tent.ideal_for}}
{{/if}}

{{#if tent.manufacturer_claims}}
## Ce que dit le fabricant

{{tent.manufacturer_claims}}
{{/if}}

{{#if tent.care_instructions}}
## Entretien

{{tent.care_instructions}}
{{/if}}

{{#if tent.repair_notes}}
## Réparabilité

{{tent.repair_notes}}
{{/if}}

{{#if tent.compatible_accessories}}
## Accessoires compatibles

{{tent.compatible_accessories}}
{{/if}}
```

- [ ] **Step 2: Commit**

```bash
git add templates/tent-page.template.mdx
git commit -m "feat: tent page MDX template"
```

---

## Task 8: Next.js App — Layout + Navigation

**Files:**
- Modify: `src/app/layout.tsx`
- Create: `src/app/page.tsx` (homepage)

- [ ] **Step 1: Update layout.tsx**

```typescript
// src/app/layout.tsx
import type { Metadata } from 'next'
import { Geist } from 'next/font/google'
import Link from 'next/link'
import './globals.css'

const geist = Geist({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'MatosTrek — Matériel ultralight',
  description: 'Guide du matériel de randonnée ultralight',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr">
      <body className={`${geist.className} bg-white text-stone-900`}>
        <header className="border-b border-stone-200">
          <nav className="max-w-6xl mx-auto px-4 py-4 flex gap-8 text-sm font-medium">
            <Link href="/" className="font-bold text-base">MatosTrek</Link>
            <Link href="/tentes" className="hover:text-stone-600">Tentes</Link>
            <Link href="/duvets" className="hover:text-stone-600">Duvets</Link>
            <Link href="/materiaux" className="hover:text-stone-600">Matériaux</Link>
          </nav>
        </header>
        <main className="max-w-6xl mx-auto px-4 py-8">
          {children}
        </main>
      </body>
    </html>
  )
}
```

- [ ] **Step 2: Create homepage**

```typescript
// src/app/page.tsx
import Link from 'next/link'

export default function HomePage() {
  return (
    <div className="py-16">
      <h1 className="text-4xl font-bold mb-4">MatosTrek</h1>
      <p className="text-stone-600 text-lg mb-8">
        Guide du matériel de randonnée ultralight — tentes, sacs de couchage, matelas.
      </p>
      <Link
        href="/tentes"
        className="inline-block bg-stone-900 text-white px-6 py-3 rounded-lg hover:bg-stone-700"
      >
        Explorer les tentes →
      </Link>
    </div>
  )
}
```

- [ ] **Step 3: Commit**

```bash
git add src/app/layout.tsx src/app/page.tsx
git commit -m "feat: root layout with nav + homepage"
```

---

## Task 9: Tent Listing Page

**Files:**
- Create: `src/app/tentes/page.tsx`

- [ ] **Step 1: Create tent listing page**

```typescript
// src/app/tentes/page.tsx
import Link from 'next/link'
import { listTents } from '@/lib/nocodb'

export default async function TentesPage() {
  let tents: any[] = []
  try {
    const data = await listTents()
    tents = data.list ?? []
  } catch {
    // DB empty or not yet populated
  }

  return (
    <div>
      <h1 className="text-3xl font-bold mb-8">Tentes ultralight</h1>
      {tents.length === 0 ? (
        <p className="text-stone-500">Aucune tente en base — donne des URLs à l'agent pour commencer.</p>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {tents.map((tent: any) => (
            <Link
              key={tent.Id}
              href={`/tentes/${tent.slug}`}
              className="border border-stone-200 rounded-xl p-6 hover:border-stone-400 transition-colors"
            >
              <p className="text-xs text-stone-400 mb-1 uppercase tracking-wide">
                {tent.season_rating} · {tent.structure_type}
              </p>
              <h2 className="text-xl font-semibold mb-2">{tent.name}</h2>
              {tent.tagline && (
                <p className="text-stone-600 text-sm line-clamp-2">{tent.tagline}</p>
              )}
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
```

- [ ] **Step 2: Commit**

```bash
git add src/app/tentes/page.tsx
git commit -m "feat: tent listing page"
```

---

## Task 10: Tent Detail Page

**Files:**
- Create: `src/app/tentes/[slug]/page.tsx`

- [ ] **Step 1: Create tent detail page**

```typescript
// src/app/tentes/[slug]/page.tsx
import { notFound } from 'next/navigation'
import { getTentBySlug, getTentVariants, getTentSpecsExtra, getBrandById } from '@/lib/nocodb'

function g(val: number | null) {
  if (!val) return null
  return `${val}g / ${(val / 28.3495).toFixed(1)}oz`
}

function cm(val: number | null) {
  if (!val) return null
  return `${val}cm / ${(val / 2.54).toFixed(1)}"`
}

export default async function TentPage({ params }: { params: { slug: string } }) {
  const tent = await getTentBySlug(params.slug)
  if (!tent) notFound()

  const [variants, specsExtra, brand] = await Promise.all([
    getTentVariants(tent.Id),
    getTentSpecsExtra(tent.Id),
    tent.brand_id ? getBrandById(tent.brand_id) : null,
  ])

  return (
    <article className="max-w-4xl">
      {brand && (
        <p className="text-sm text-stone-400 uppercase tracking-widest mb-2">{brand.name}</p>
      )}
      <h1 className="text-4xl font-bold mb-2">{tent.name}</h1>
      {tent.tagline && (
        <p className="text-xl text-stone-600 mb-8">{tent.tagline}</p>
      )}

      {tent.description && (
        <section className="mb-10">
          <p className="text-stone-700 leading-relaxed">{tent.description}</p>
        </section>
      )}

      {/* Key specs grid */}
      <section className="mb-10 grid grid-cols-2 md:grid-cols-4 gap-4">
        {tent.capacity && (
          <div className="bg-stone-50 rounded-lg p-4">
            <p className="text-xs text-stone-400 mb-1">Capacité</p>
            <p className="text-2xl font-bold">{tent.capacity}P</p>
          </div>
        )}
        {tent.season_rating && (
          <div className="bg-stone-50 rounded-lg p-4">
            <p className="text-xs text-stone-400 mb-1">Saison</p>
            <p className="text-2xl font-bold">{tent.season_rating}</p>
          </div>
        )}
        {tent.door_count && (
          <div className="bg-stone-50 rounded-lg p-4">
            <p className="text-xs text-stone-400 mb-1">Portes</p>
            <p className="text-2xl font-bold">{tent.door_count}</p>
          </div>
        )}
        {tent.vestibule_count && (
          <div className="bg-stone-50 rounded-lg p-4">
            <p className="text-xs text-stone-400 mb-1">Absides</p>
            <p className="text-2xl font-bold">{tent.vestibule_count}</p>
          </div>
        )}
      </section>

      {/* Variants / Weight */}
      {variants.length > 0 && (
        <section className="mb-10">
          <h2 className="text-2xl font-semibold mb-4">Poids & Variantes</h2>
          <div className="space-y-4">
            {variants.map((v: any) => (
              <div key={v.Id} className="border border-stone-200 rounded-lg p-4">
                <h3 className="font-semibold mb-2">{v.variant_name}</h3>
                <dl className="grid grid-cols-2 gap-x-8 gap-y-1 text-sm">
                  {v.weight_tent_g && (
                    <><dt className="text-stone-400">Poids complet</dt><dd>{g(v.weight_tent_g)}</dd></>
                  )}
                  {v.weight_typical_g && (
                    <><dt className="text-stone-400">Poids typique</dt><dd>{g(v.weight_typical_g)}</dd></>
                  )}
                  {v.packed_length_cm && (
                    <><dt className="text-stone-400">Emballé</dt><dd>{v.packed_length_cm}cm × ⌀{v.packed_diameter_cm}cm</dd></>
                  )}
                  {v.price_eur && (
                    <><dt className="text-stone-400">Prix</dt><dd>{v.price_eur} €</dd></>
                  )}
                </dl>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* Dimensions */}
      {(tent.floor_length_cm || tent.floor_area_sqm || tent.peak_height_inner_cm) && (
        <section className="mb-10">
          <h2 className="text-2xl font-semibold mb-4">Dimensions</h2>
          <dl className="grid grid-cols-2 gap-x-8 gap-y-2 text-sm">
            {tent.floor_length_cm && tent.floor_width_cm && (
              <><dt className="text-stone-400">Sol</dt><dd>{tent.floor_length_cm} × {tent.floor_width_cm} cm</dd></>
            )}
            {tent.floor_area_sqm && (
              <><dt className="text-stone-400">Surface</dt><dd>{tent.floor_area_sqm} m²</dd></>
            )}
            {tent.peak_height_inner_cm && (
              <><dt className="text-stone-400">Hauteur intérieure</dt><dd>{cm(tent.peak_height_inner_cm)}</dd></>
            )}
            {tent.vestibule_area_sqm && (
              <><dt className="text-stone-400">Surface abside</dt><dd>{tent.vestibule_area_sqm} m²</dd></>
            )}
          </dl>
        </section>
      )}

      {/* Materials */}
      {(tent.fly_fabric || tent.floor_fabric || tent.inner_fabric) && (
        <section className="mb-10">
          <h2 className="text-2xl font-semibold mb-4">Matériaux</h2>
          <dl className="grid grid-cols-2 gap-x-8 gap-y-2 text-sm">
            {tent.fly_fabric && (
              <><dt className="text-stone-400">Double toit</dt><dd>{tent.fly_fabric}{tent.fly_waterproofness_mm ? ` — ${tent.fly_waterproofness_mm}mm` : ''}</dd></>
            )}
            {tent.floor_fabric && (
              <><dt className="text-stone-400">Plancher</dt><dd>{tent.floor_fabric}{tent.floor_waterproofness_mm ? ` — ${tent.floor_waterproofness_mm}mm` : ''}</dd></>
            )}
            {tent.inner_fabric && (
              <><dt className="text-stone-400">Intérieur</dt><dd>{tent.inner_fabric}</dd></>
            )}
            {tent.seam_construction && (
              <><dt className="text-stone-400">Coutures</dt><dd>{tent.seam_construction}</dd></>
            )}
          </dl>
        </section>
      )}

      {/* Key features */}
      {tent.key_features && (
        <section className="mb-10">
          <h2 className="text-2xl font-semibold mb-4">Points forts</h2>
          <p className="text-stone-700 leading-relaxed whitespace-pre-line">{tent.key_features}</p>
        </section>
      )}

      {/* Ideal for */}
      {tent.ideal_for && (
        <section className="mb-10">
          <h2 className="text-2xl font-semibold mb-4">Pour qui ?</h2>
          <p className="text-stone-700 leading-relaxed">{tent.ideal_for}</p>
        </section>
      )}

      {/* Specs extra */}
      {specsExtra.length > 0 && (
        <section className="mb-10">
          <h2 className="text-2xl font-semibold mb-4">Specs complémentaires</h2>
          <dl className="grid grid-cols-2 gap-x-8 gap-y-2 text-sm">
            {specsExtra.map((s: any) => (
              <>
                <dt key={`k-${s.Id}`} className="text-stone-400">{s.label}</dt>
                <dd key={`v-${s.Id}`}>{s.value}{s.unit ? ` ${s.unit}` : ''}</dd>
              </>
            ))}
          </dl>
        </section>
      )}

      {/* Care + repair */}
      {tent.care_instructions && (
        <section className="mb-10">
          <h2 className="text-2xl font-semibold mb-4">Entretien</h2>
          <p className="text-stone-700 leading-relaxed whitespace-pre-line">{tent.care_instructions}</p>
        </section>
      )}

      {tent.repair_notes && (
        <section className="mb-10">
          <h2 className="text-2xl font-semibold mb-4">Réparabilité</h2>
          <p className="text-stone-700 leading-relaxed whitespace-pre-line">{tent.repair_notes}</p>
        </section>
      )}

      {/* Source link */}
      {tent.product_url && (
        <section className="mt-12 pt-8 border-t border-stone-200">
          <a
            href={tent.product_url}
            target="_blank"
            rel="noopener noreferrer"
            className="text-sm text-stone-400 hover:text-stone-600"
          >
            Source officielle →
          </a>
        </section>
      )}
    </article>
  )
}
```

- [ ] **Step 2: Commit**

```bash
git add src/app/tentes/[slug]/page.tsx
git commit -m "feat: tent detail page with all spec sections"
```

---

## Task 11: Save Memory

- [ ] **Step 1: Save project memory**

This step is done by the Claude Code agent, not a shell command. The agent saves:
- project name: MatosTrek
- NocoDB base ID: `EXAMPLE_BASE_ID`
- NocoDB URL: `http://localhost:8080`
- Stack: Next.js 15 App Router, TypeScript, Tailwind, NocoDB

---

## Self-Review

**Spec coverage:**
- ✅ Next.js 15 + TypeScript + Tailwind
- ✅ NocoDB tables (brands, tents, tent_variants, tent_specs_extra)
- ✅ .env + .mcp.json
- ✅ CLAUDE.md agent rules
- ✅ raw_data/ folder structure
- ✅ templates/tent-page.template.mdx
- ✅ content/tents/ folder
- ✅ Tent listing + detail pages
- ✅ Unit conversions (g→oz, cm→inches) at display only
- ✅ Deduplication rule (slug)
- ✅ schema.sql reference

**Placeholders:** None — all steps have concrete code or commands.

**Type consistency:** `tent.Id` used throughout (NocoDB auto-ID is `Id` not `id`). `nocodb.ts` uses `/db/data/noco/${BASE_ID}/<table>` path consistently.
