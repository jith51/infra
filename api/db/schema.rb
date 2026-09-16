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

ActiveRecord::Schema[8.1].define(version: 2026_08_18_065043) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "apic_L3Out", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "tenant_id", null: false
    t.index ["name"], name: "index_apic_L3Out_on_name"
    t.index ["tenant_id"], name: "index_apic_L3Out_on_tenant_id"
  end

  create_table "apic_L3Out_domaines", id: false, force: :cascade do |t|
    t.bigint "apic_L3Out_id", null: false
    t.bigint "apic_domaine_id", null: false
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
    t.bigint "apic_context_id", null: false
    t.bigint "apic_domaine_id", null: false
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
    t.bigint "apic_domaine_attribut_id", null: false
    t.bigint "apic_epg_id", null: false
  end

  create_table "apic_domaines", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "tenant_id", null: false
    t.index ["name"], name: "index_apic_domaines_on_name"
    t.index ["tenant_id"], name: "index_apic_domaines_on_tenant_id"
  end

  create_table "apic_epgs", force: :cascade do |t|
    t.bigint "application_profile_id", null: false
    t.bigint "domaine_id", null: false
    t.string "name", null: false
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
    t.integer "epg_id", null: false
    t.string "name", null: false
    t.string "os"
    t.integer "powerstate"
    t.index ["epg_id"], name: "index_apic_serveurs_on_epg_id"
    t.index ["name"], name: "index_apic_serveurs_on_name"
  end

  create_table "apic_subnets", force: :cascade do |t|
    t.bigint "domaine_id", null: false
    t.string "name", null: false
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
    t.bigint "contractable_id"
    t.string "contractable_type"
    t.bigint "contrat_id", null: false
    t.string "type"
    t.index ["contractable_type", "contractable_id"], name: "index_apic_used_contrats_on_contractable"
    t.index ["contrat_id"], name: "index_apic_used_contrats_on_contrat_id"
    t.index ["type"], name: "index_apic_used_contrats_on_type"
  end

  create_table "apic_used_filters", force: :cascade do |t|
    t.bigint "contrat_id", null: false
    t.string "type"
    t.bigint "vzFilter_id", null: false
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
    t.bigint "device_family_id"
    t.bigint "device_platform_id_id"
    t.bigint "device_role_id"
    t.bigint "device_series_id"
    t.bigint "device_software_type_id"
    t.bigint "device_type_id"
    t.string "hostname"
    t.string "location"
    t.string "mac_address"
    t.string "management_ip"
    t.string "serial_number"
    t.string "software_version"
    t.string "uuid"
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
    t.date "end_of_life_date"
    t.string "eol_type"
    t.date "last_date_of_support"
    t.string "name"
    t.string "number"
    t.string "url"
    t.index ["eol_type", "number"], name: "index_dna_eol_bulletins_on_eol_type_and_number", unique: true
  end

  create_table "dna_equipement_types", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_dna_equipement_types_on_name", unique: true
  end

  create_table "dna_equipements", force: :cascade do |t|
    t.string "description"
    t.bigint "equipement_type_id"
    t.bigint "host_id", null: false
    t.string "host_type", null: false
    t.string "name"
    t.bigint "product_id_id"
    t.string "serial_number"
    t.string "uuid"
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
    t.string "description"
    t.bigint "device_id"
    t.bigint "equipement_type_id"
    t.string "mac_address"
    t.string "role"
    t.string "serial_number"
    t.string "software_image"
    t.string "stack_member_number"
    t.bigint "switch_platform_id_id"
    t.string "uuid"
    t.index ["device_id"], name: "index_dna_switches_on_device_id"
    t.index ["equipement_type_id"], name: "index_dna_switches_on_equipement_type_id"
    t.index ["switch_platform_id_id"], name: "index_dna_switches_on_switch_platform_id_id"
  end

  create_table "physical_chassis", force: :cascade do |t|
    t.bigint "chassis_class_id", null: false
    t.datetime "created_at", null: false
    t.jsonb "custom_attributes", default: {}, null: false
    t.string "name", null: false
    t.string "serial_number"
    t.datetime "updated_at", null: false
    t.index ["chassis_class_id"], name: "index_physical_chassis_on_chassis_class_id"
    t.index ["name"], name: "index_physical_chassis_on_name", unique: true
  end

  create_table "physical_chassis_classes", force: :cascade do |t|
    t.bigint "chassis_powertype_id"
    t.datetime "created_at", null: false
    t.jsonb "custom_attributes", default: {}, null: false
    t.jsonb "custom_attributes_definition", default: {}, null: false
    t.string "fournisseur"
    t.integer "height"
    t.string "model"
    t.string "name", null: false
    t.string "part_number"
    t.datetime "updated_at", null: false
    t.string "url_link"
    t.string "vendor_equipment_type"
    t.string "version"
    t.index ["chassis_powertype_id"], name: "index_physical_chassis_classes_on_chassis_powertype_id"
    t.index ["name"], name: "index_physical_chassis_classes_on_name", unique: true
  end

  create_table "physical_component_slots", force: :cascade do |t|
    t.bigint "chassis_class_id", null: false
    t.bigint "component_type_id", null: false
    t.string "description"
    t.string "name", null: false
    t.index ["chassis_class_id"], name: "index_physical_component_slots_on_chassis_class_id"
    t.index ["component_type_id"], name: "index_physical_component_slots_on_component_type_id"
    t.index ["name"], name: "index_physical_component_slots_on_name"
  end

  create_table "physical_component_types", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_physical_component_types_on_name"
  end

  create_table "physical_components", force: :cascade do |t|
    t.bigint "chassis_id", null: false
    t.bigint "component_type_id", null: false
    t.string "description"
    t.string "name", null: false
    t.string "serial_number"
    t.index ["chassis_id"], name: "index_physical_components_on_chassis_id"
    t.index ["component_type_id"], name: "index_physical_components_on_component_type_id"
    t.index ["name"], name: "index_physical_components_on_name"
  end

  create_table "physical_connections", id: false, force: :cascade do |t|
    t.bigint "distant_port_id", null: false
    t.bigint "link_type_id"
    t.bigint "local_port_id", null: false
    t.index ["distant_port_id"], name: "index_physical_connections_on_distant_port_id"
    t.index ["link_type_id"], name: "index_physical_connections_on_link_type_id"
    t.index ["local_port_id", "distant_port_id"], name: "idx_on_local_port_id_distant_port_id_1461e3b85d", unique: true
    t.index ["local_port_id"], name: "index_physical_connections_on_local_port_id"
  end

  create_table "physical_interface_types", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_physical_interface_types_on_name"
  end

  create_table "physical_link_types", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_physical_link_types_on_name"
  end

  create_table "physical_port_slots", force: :cascade do |t|
    t.bigint "chassis_class_id", null: false
    t.string "description"
    t.string "name", null: false
    t.bigint "port_type_id", null: false
    t.index ["chassis_class_id"], name: "index_physical_port_slots_on_chassis_class_id"
    t.index ["name"], name: "index_physical_port_slots_on_name"
    t.index ["port_type_id"], name: "index_physical_port_slots_on_port_type_id"
  end

  create_table "physical_port_types", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_physical_port_types_on_name"
  end

  create_table "physical_ports", force: :cascade do |t|
    t.bigint "chassis_id", null: false
    t.string "description"
    t.string "mac_address"
    t.string "name", null: false
    t.bigint "port_type_id"
    t.index ["chassis_id"], name: "index_physical_ports_on_chassis_id"
    t.index ["name"], name: "index_physical_ports_on_name"
    t.index ["port_type_id"], name: "index_physical_ports_on_port_type_id"
  end

  create_table "physical_powertypes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "custom_attributes", default: {}
    t.string "name"
    t.integer "parent_id"
    t.string "type"
    t.datetime "updated_at", null: false
  end

  create_table "powertype_hierarchies", id: false, force: :cascade do |t|
    t.bigint "ancestor_id", null: false
    t.bigint "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "powertype_anc_desc_idx", unique: true
    t.index ["ancestor_id"], name: "index_powertype_hierarchies_on_ancestor_id"
    t.index ["descendant_id"], name: "index_powertype_hierarchies_on_descendant_id"
    t.index ["descendant_id"], name: "powertype_desc_idx"
  end

  create_table "powertypes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "custom_attributes_definition", default: {}, null: false
    t.string "name"
    t.integer "parent_id"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["type", "name"], name: "index_powertypes_on_type_and_name", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "tags_attachments", id: false, force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "taggable_id"
    t.string "taggable_type"
    t.index ["tag_id"], name: "index_tags_attachments_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_tags_attachments_on_taggable"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "physical_chassis", "physical_chassis_classes", column: "chassis_class_id", on_delete: :restrict
  add_foreign_key "physical_chassis_classes", "powertypes", column: "chassis_powertype_id", on_delete: :restrict
  add_foreign_key "physical_component_slots", "physical_chassis_classes", column: "chassis_class_id", on_delete: :cascade
  add_foreign_key "physical_component_slots", "physical_component_types", column: "component_type_id", on_delete: :restrict
  add_foreign_key "physical_components", "physical_chassis", column: "chassis_id", on_delete: :cascade
  add_foreign_key "physical_components", "physical_component_types", column: "component_type_id", on_delete: :restrict
  add_foreign_key "physical_connections", "physical_link_types", column: "link_type_id", on_delete: :restrict
  add_foreign_key "physical_connections", "physical_ports", column: "distant_port_id", on_delete: :cascade
  add_foreign_key "physical_connections", "physical_ports", column: "local_port_id", on_delete: :cascade
  add_foreign_key "physical_port_slots", "physical_chassis_classes", column: "chassis_class_id", on_delete: :cascade
  add_foreign_key "physical_port_slots", "physical_port_types", column: "port_type_id", on_delete: :restrict
  add_foreign_key "physical_ports", "physical_chassis", column: "chassis_id", on_delete: :cascade
  add_foreign_key "physical_ports", "physical_port_types", column: "port_type_id", on_delete: :restrict
  add_foreign_key "powertype_hierarchies", "powertypes", column: "ancestor_id", on_delete: :cascade
  add_foreign_key "powertype_hierarchies", "powertypes", column: "descendant_id", on_delete: :cascade
end
