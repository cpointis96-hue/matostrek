-- Référence schéma MatosTrek (SQLite)
-- Structure logique — les tables réelles dans Matostrek.db portent le préfixe "nc_7pgf___"
-- Exemple : "brands" → "nc_7pgf___brands"

CREATE TABLE brands (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  country TEXT,
  website_url TEXT
);

CREATE TABLE tents (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  brand_id INTEGER REFERENCES brands(id),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  -- Textes informatifs
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
  -- Classification
  capacity INTEGER,
  season_rating TEXT,           -- 3-season | 4-season | 3-4-season
  structure_type TEXT,          -- freestanding | semi-freestanding | non-freestanding
  wall_type TEXT,               -- double | single | hybrid
  poles_required TEXT,          -- trekking | dedicated | none
  poles_included BOOLEAN,
  geometry_name TEXT,
  geometry_patented BOOLEAN,
  -- Comptages
  door_count INTEGER,
  vestibule_count INTEGER,
  vent_count INTEGER,
  interior_pockets INTEGER,
  guy_lines_max INTEGER,
  stake_points_max INTEGER,
  -- Dimensions intérieures (cm)
  floor_length_cm REAL,
  floor_width_cm REAL,
  floor_width_head_cm REAL,
  floor_width_foot_cm REAL,
  floor_area_sqm REAL,
  floor_bathtub_height_cm REAL,
  floor_height_adjustable BOOLEAN,
  peak_height_inner_cm REAL,
  peak_height_fly_cm REAL,
  -- Abside (cm)
  vestibule_area_sqm REAL,
  vestibule_depth_cm REAL,
  -- Double toit (cm)
  fly_length_cm REAL,
  fly_width_cm REAL,
  -- Matériaux
  fly_fabric TEXT,
  fly_fabric_type TEXT,         -- polyester | nylon | DCF | silpoly | silnylon
  fly_waterproofness_mm INTEGER,
  fly_pfas_free BOOLEAN,
  floor_fabric TEXT,
  floor_fabric_type TEXT,
  floor_waterproofness_mm INTEGER,
  inner_fabric TEXT,
  inner_mesh BOOLEAN,
  seam_construction TEXT,       -- taped | hot-bonded | none
  seam_waterproof BOOLEAN,
  zipper_fly TEXT,
  zipper_inner TEXT,
  magnetic_toggles BOOLEAN,
  -- Arceaux
  pole_diameter_mm REAL,
  pole_sleeve_material TEXT,
  pole_splint_included BOOLEAN,
  pole_jack_included BOOLEAN,
  -- Ancrages
  tie_out_count_perimeter INTEGER,
  tie_out_count_midpanel INTEGER,
  tie_out_count_apex INTEGER,
  ladder_locks BOOLEAN,
  guyline_brand TEXT,
  -- Features booléennes
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
  -- Accessoires inclus
  manufacture_country TEXT,
  stakes_included INTEGER,
  stakes_type TEXT,
  stuff_sack_included BOOLEAN,
  repair_kit_included BOOLEAN,
  carry_bag_included BOOLEAN,
  -- Prix et garantie
  price_usd REAL,
  price_eur REAL,
  product_url TEXT NOT NULL,
  warranty_years INTEGER
);

CREATE TABLE tent_variants (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tent_id INTEGER REFERENCES tents(id),
  variant_name TEXT NOT NULL,
  variant_slug TEXT NOT NULL,
  pole_option TEXT,
  floor_option TEXT,
  inner_option TEXT,
  color TEXT,
  -- Poids (grammes uniquement)
  weight_tent_g REAL,
  weight_fly_g REAL,
  weight_inner_g REAL,
  weight_poles_g REAL,
  weight_body_g REAL,
  weight_guy_lines_g REAL,
  weight_stakes_g REAL,
  weight_stuff_sack_g REAL,
  weight_repair_kit_g REAL,
  weight_accessories_g REAL,
  weight_minimum_g REAL,
  weight_packed_g REAL,
  weight_displayed_g REAL,
  weight_typical_g REAL,
  weight_typical_notes TEXT,
  weight_scope_notes TEXT,
  -- Dimensions emballé (cm uniquement)
  packed_length_cm REAL,
  packed_diameter_cm REAL,
  -- Prix
  price_usd REAL,
  price_eur REAL,
  in_stock BOOLEAN
);

CREATE TABLE tent_specs_extra (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tent_id INTEGER REFERENCES tents(id),
  key TEXT NOT NULL,
  value TEXT NOT NULL,
  unit TEXT,
  label TEXT NOT NULL,
  category TEXT NOT NULL
);

CREATE TABLE sleeping_bags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  brand_id INTEGER REFERENCES brands(id),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  series TEXT,
  product_type TEXT,
  subtitle TEXT,
  season_positioning TEXT,
  shape TEXT,
  product_url TEXT,
  category_url TEXT,
  configurator_url TEXT,
  price_eur REAL,
  price_eur_alt REAL,
  price_pln REAL,
  lead_time_product TEXT,
  lead_time_configurator TEXT,
  tax_notice_visible BOOLEAN,
  weight_g REAL,
  down_weight_g REAL,
  unfilled_weight_g REAL,
  comfort_c REAL,
  limit_c REAL,
  extreme_c REAL,
  fill_power_fp INTEGER,
  fill_material TEXT,
  fill_origin TEXT,
  ethically_sourced BOOLEAN,
  fill_proportions TEXT,
  shell_fabric TEXT,
  shell_fabric_weight_gsm REAL,
  shell_fabric_color TEXT,
  liner_fabric TEXT,
  liner_fabric_weight_gsm REAL,
  liner_fabric_color TEXT,
  fabric_denier TEXT,
  fabric_composition TEXT,
  fabric_finish TEXT,
  zipper_brand TEXT,
  zipper_spec TEXT,
  zipper_side_options TEXT,
  hood_type TEXT,
  footbox_type TEXT,
  chamber_construction TEXT,
  chamber_count INTEGER,
  differential_cut BOOLEAN,
  maximum_user_height_cm REAL,
  length_cm REAL,
  width_top_cm REAL,
  width_bottom_cm REAL,
  stuffsack_height_cm REAL,
  stuffsack_diameter_cm REAL,
  stuffsack_volume_l REAL,
  made_in TEXT,
  warranty_name TEXT,
  key_features TEXT,
  marketing_summary TEXT,
  manufacturer_claims TEXT,
  use_cases TEXT,
  customization_options TEXT,
  source_notes TEXT,
  raw_source_urls TEXT,
  current_status TEXT
);
