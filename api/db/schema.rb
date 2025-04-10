# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_03_20_080530) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apic_L3Out", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "tenant_id", null: false
    t.index ["name"], name: "index_apic_L3Out_on_name"
    t.index ["tenant_id"], name: "index_apic_L3Out_on_tenant_id"
  end

  create_table "apic_L3Out_domaines", id: false, force: :cascade do |t|
    t.bigint "apic_domaine_id", null: false
    t.bigint "apic_L3Out_id", null: false
  end

  create_table "apic_application_profiles", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "tenant_id", null: false
    t.index ["name"], name: "index_apic_application_profiles_on_name"
    t.index ["tenant_id"], name: "index_apic_application_profiles_on_tenant_id"
  end

  create_table "apic_contexts", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "tenant_id", null: false
    t.index ["name"], name: "index_apic_contexts_on_name"
    t.index ["tenant_id"], name: "index_apic_contexts_on_tenant_id"
  end

  create_table "apic_contexts_domaines", id: false, force: :cascade do |t|
    t.bigint "apic_domaine_id", null: false
    t.bigint "apic_context_id", null: false
  end

  create_table "apic_contrats", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "tenant_id", null: false
    t.index ["name"], name: "index_apic_contrats_on_name"
    t.index ["tenant_id"], name: "index_apic_contrats_on_tenant_id"
  end

  create_table "apic_domaine_attributs", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_apic_domaine_attributs_on_name"
  end

  create_table "apic_domaine_attributs_epgs", id: false, force: :cascade do |t|
    t.bigint "apic_epg_id", null: false
    t.bigint "apic_domaine_attribut_id", null: false
  end

  create_table "apic_domaines", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "tenant_id", null: false
    t.index ["name"], name: "index_apic_domaines_on_name"
    t.index ["tenant_id"], name: "index_apic_domaines_on_tenant_id"
  end

  create_table "apic_epgs", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "application_profile_id", null: false
    t.bigint "domaine_id", null: false
    t.index ["application_profile_id"], name: "index_apic_epgs_on_application_profile_id"
    t.index ["domaine_id"], name: "index_apic_epgs_on_domaine_id"
    t.index ["name"], name: "index_apic_epgs_on_name"
  end

  create_table "apic_epgs_path_attributs", id: false, force: :cascade do |t|
    t.bigint "apic_epg_id", null: false
    t.bigint "apic_path_attribut_id", null: false
  end

  create_table "apic_path_attributs", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_apic_path_attributs_on_name"
  end

  create_table "apic_serveurs", force: :cascade do |t|
    t.string "name", null: false
    t.integer "epg_id", null: false
    t.integer "powerstate"
    t.string "os"
    t.index ["epg_id"], name: "index_apic_serveurs_on_epg_id"
    t.index ["name"], name: "index_apic_serveurs_on_name"
  end

  create_table "apic_subnets", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "domaine_id", null: false
    t.index ["domaine_id"], name: "index_apic_subnets_on_domaine_id"
    t.index ["name"], name: "index_apic_subnets_on_name"
  end

  create_table "apic_tasks", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "apic_tenants", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_apic_tenants_on_name"
  end

  create_table "apic_used_contrats", force: :cascade do |t|
    t.string "type"
    t.bigint "contrat_id", null: false
    t.string "contractable_type"
    t.bigint "contractable_id"
    t.index ["contractable_type", "contractable_id"], name: "index_apic_used_contrats_on_contractable"
    t.index ["contrat_id"], name: "index_apic_used_contrats_on_contrat_id"
    t.index ["type"], name: "index_apic_used_contrats_on_type"
  end

  create_table "apic_used_filters", force: :cascade do |t|
    t.string "type"
    t.bigint "vzFilter_id", null: false
    t.bigint "contrat_id", null: false
    t.index ["contrat_id"], name: "index_apic_used_filters_on_contrat_id"
    t.index ["type"], name: "index_apic_used_filters_on_type"
    t.index ["vzFilter_id"], name: "index_apic_used_filters_on_vzFilter_id"
  end

  create_table "apic_vzFilter", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "tenant_id", null: false
    t.index ["name"], name: "index_apic_vzFilter_on_name"
    t.index ["tenant_id"], name: "index_apic_vzFilter_on_tenant_id"
  end

  create_table "dna_device_families", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_dna_device_families_on_name", unique: true
  end

  create_table "dna_device_platform_ids", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_dna_device_platform_ids_on_name", unique: true
  end

  create_table "dna_device_roles", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_dna_device_roles_on_name", unique: true
  end

  create_table "dna_device_series", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_dna_device_series_on_name", unique: true
  end

  create_table "dna_device_software_types", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_dna_device_software_types_on_name", unique: true
  end

  create_table "dna_device_types", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_dna_device_types_on_name", unique: true
  end

  create_table "dna_devices", force: :cascade do |t|
    t.string "description"
    t.string "software_version"
    t.string "mac_address"
    t.string "serial_number"
    t.string "hostname"
    t.string "management_ip"
    t.string "location"
    t.string "uuid"
    t.bigint "device_family_id"
    t.bigint "device_platform_id_id"
    t.bigint "device_software_type_id"
    t.bigint "device_series_id"
    t.bigint "device_type_id"
    t.bigint "device_role_id"
    t.index ["device_family_id"], name: "index_dna_devices_on_device_family_id"
    t.index ["device_platform_id_id"], name: "index_dna_devices_on_device_platform_id_id"
    t.index ["device_role_id"], name: "index_dna_devices_on_device_role_id"
    t.index ["device_series_id"], name: "index_dna_devices_on_device_series_id"
    t.index ["device_software_type_id"], name: "index_dna_devices_on_device_software_type_id"
    t.index ["device_type_id"], name: "index_dna_devices_on_device_type_id"
    t.index ["uuid"], name: "index_dna_devices_on_uuid", unique: true
  end

  create_table "dna_devices_eol_bulletins", id: false, force: :cascade do |t|
    t.bigint "device_id"
    t.bigint "eol_bulletin_id"
    t.index ["device_id", "eol_bulletin_id"], name: "idx_on_device_id_eol_bulletin_id_3341dc7c30", unique: true
    t.index ["device_id"], name: "index_dna_devices_eol_bulletins_on_device_id"
    t.index ["eol_bulletin_id"], name: "index_dna_devices_eol_bulletins_on_eol_bulletin_id"
  end

  create_table "dna_eol_bulletins", force: :cascade do |t|
    t.string "number"
    t.string "name"
    t.string "eol_type"
    t.string "url"
    t.date "end_of_life_date"
    t.date "last_date_of_support"
    t.index ["eol_type", "number"], name: "index_dna_eol_bulletins_on_eol_type_and_number", unique: true
  end

  create_table "dna_equipement_types", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_dna_equipement_types_on_name", unique: true
  end

  create_table "dna_equipements", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "serial_number"
    t.string "uuid"
    t.bigint "product_id_id"
    t.bigint "equipement_type_id"
    t.string "host_type", null: false
    t.bigint "host_id", null: false
    t.index ["equipement_type_id"], name: "index_dna_equipements_on_equipement_type_id"
    t.index ["host_type", "host_id"], name: "index_dna_equipements_on_host"
    t.index ["product_id_id"], name: "index_dna_equipements_on_product_id_id"
    t.index ["uuid"], name: "index_dna_equipements_on_uuid", unique: true
  end

  create_table "dna_product_ids", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_dna_product_ids_on_name", unique: true
  end

  create_table "dna_switch_platform_ids", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_dna_switch_platform_ids_on_name", unique: true
  end

  create_table "dna_switches", force: :cascade do |t|
    t.string "uuid"
    t.string "description"
    t.string "mac_address"
    t.string "serial_number"
    t.string "role"
    t.string "stack_member_number"
    t.string "software_image"
    t.bigint "switch_platform_id_id"
    t.bigint "equipement_type_id"
    t.bigint "device_id"
    t.index ["device_id"], name: "index_dna_switches_on_device_id"
    t.index ["equipement_type_id"], name: "index_dna_switches_on_equipement_type_id"
    t.index ["switch_platform_id_id"], name: "index_dna_switches_on_switch_platform_id_id"
  end

end
