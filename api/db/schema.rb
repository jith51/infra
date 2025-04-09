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

ActiveRecord::Schema[7.1].define(version: 2025_03_20_083417) do
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

  create_table "cis", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "computer_system_type", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "computer_systems", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "operating_system_id"
    t.bigint "computer_system_type_id"
    t.string "host_type"
    t.bigint "host_id"
    t.integer "total_cpu"
    t.integer "total_noyau_cpu"
    t.float "cpu_speed"
    t.string "cpu_speed_unity"
    t.float "total_ram"
    t.string "ram_unity"
    t.integer "hard_disk_number"
    t.float "had_disk_size"
    t.string "hard_disk_unity"
    t.string "raid_type"
    t.boolean "software_raid"
    t.index ["computer_system_type_id"], name: "index_computer_systems_on_computer_system_type_id"
    t.index ["host_type", "host_id"], name: "index_computer_systems_on_host"
    t.index ["operating_system_id"], name: "index_computer_systems_on_operating_system_id"
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
    t.string "role"
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

  create_table "documentation_file_states", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "documentation_file_types", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "documentation_files", force: :cascade do |t|
    t.string "name", null: false
    t.string "path", null: false
    t.bigint "file_type_id", null: false
    t.bigint "status_id"
    t.bigint "cis_id"
    t.bigint "teams_id"
    t.date "last_access"
    t.index ["cis_id"], name: "index_documentation_files_on_cis_id"
    t.index ["file_type_id"], name: "index_documentation_files_on_file_type_id"
    t.index ["name"], name: "index_documentation_files_on_name"
    t.index ["path"], name: "index_documentation_files_on_path"
    t.index ["status_id"], name: "index_documentation_files_on_status_id"
    t.index ["teams_id"], name: "index_documentation_files_on_teams_id"
  end

  create_table "label_parameters", force: :cascade do |t|
    t.string "type"
    t.string "label"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "network_device_roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "network_devices", force: :cascade do |t|
    t.string "name"
    t.string "mgt_ip_address"
    t.bigint "device_role_id", null: false
    t.bigint "site_id", null: false
    t.index ["device_role_id"], name: "index_network_devices_on_device_role_id"
    t.index ["site_id"], name: "index_network_devices_on_site_id"
  end

  create_table "network_site_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "site_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "site_desc_idx"
  end

  create_table "network_sites", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
  end

  create_table "network_stats", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.integer "weekly_availability"
    t.string "software_version"
    t.datetime "created_at"
    t.index ["device_id"], name: "index_network_stats_on_device_id"
  end

  create_table "operating_system", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "physical_card_classes", id: false, force: :cascade do |t|
    t.bigint "id", default: -> { "nextval('physical_element_classes_id_seq'::regclass)" }, null: false
    t.string "type"
    t.string "name"
    t.bigint "manufacturer_id"
    t.string "model"
    t.string "part_number"
    t.string "version"
    t.float "width"
    t.float "height"
    t.float "depth"
    t.float "weigth"
    t.bigint "powertype_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "test_package"
    t.string "test_card"
  end

  create_table "physical_chassis_classes", id: false, force: :cascade do |t|
    t.bigint "id", default: -> { "nextval('physical_element_classes_id_seq'::regclass)" }, null: false
    t.string "type"
    t.string "name"
    t.bigint "manufacturer_id"
    t.string "model"
    t.string "part_number"
    t.string "version"
    t.float "width"
    t.float "height"
    t.float "depth"
    t.float "weigth"
    t.bigint "powertype_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "test_package"
    t.string "test_frame"
    t.string "test_chassis"
  end

  create_table "physical_component_classes", id: false, force: :cascade do |t|
    t.bigint "id", default: -> { "nextval('physical_element_classes_id_seq'::regclass)" }, null: false
    t.string "type"
    t.string "name"
    t.bigint "manufacturer_id"
    t.string "model"
    t.string "part_number"
    t.string "version"
    t.float "width"
    t.float "height"
    t.float "depth"
    t.float "weigth"
    t.bigint "powertype_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "test_component"
  end

  create_table "physical_connected_to_associations", id: false, force: :cascade do |t|
    t.bigint "first_element_id", null: false
    t.bigint "second_element_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_element_id"], name: "physical_first_element_idx"
    t.index ["second_element_id"], name: "physical_second_element_idx"
  end

  create_table "physical_connector_classes", id: false, force: :cascade do |t|
    t.bigint "id", default: -> { "nextval('physical_element_classes_id_seq'::regclass)" }, null: false
    t.string "type"
    t.string "name"
    t.bigint "manufacturer_id"
    t.string "model"
    t.string "part_number"
    t.string "version"
    t.float "width"
    t.float "height"
    t.float "depth"
    t.float "weigth"
    t.bigint "powertype_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "test_component"
    t.string "test_connector"
  end

  create_table "physical_connector_hostings", id: false, force: :cascade do |t|
    t.bigint "connector_id", null: false
    t.bigint "package_id", null: false
    t.index ["connector_id"], name: "chosting_connector_idx"
    t.index ["package_id"], name: "chosting_package_idx"
  end

  create_table "physical_element_classes", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.bigint "manufacturer_id"
    t.string "model"
    t.string "part_number"
    t.string "version"
    t.float "width"
    t.float "height"
    t.float "depth"
    t.float "weigth"
    t.bigint "powertype_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manufacturer_id"], name: "physical_manufacturer_idx"
    t.index ["powertype_id"], name: "physical_powertype_idx"
  end

  create_table "physical_elements", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.bigint "element_class_id", null: false
    t.bigint "host_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_class_id"], name: "physical_elements_class_idx"
    t.index ["host_id"], name: "physical_elements_host_idx"
  end

  create_table "physical_frame_classes", id: false, force: :cascade do |t|
    t.bigint "id", default: -> { "nextval('physical_element_classes_id_seq'::regclass)" }, null: false
    t.string "type"
    t.string "name"
    t.bigint "manufacturer_id"
    t.string "model"
    t.string "part_number"
    t.string "version"
    t.float "width"
    t.float "height"
    t.float "depth"
    t.float "weigth"
    t.bigint "powertype_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "test_package"
    t.string "test_frame"
  end

  create_table "physical_link_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "physical_links", force: :cascade do |t|
    t.bigint "link_type_id", null: false
    t.bigint "linkable_id", null: false
    t.bigint "other_linkable_id", null: false
    t.string "reverse_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_type_id"], name: "index_physical_links_on_link_type_id"
    t.index ["linkable_id"], name: "index_physical_links_on_linkable_id"
    t.index ["other_linkable_id"], name: "index_physical_links_on_other_linkable_id"
    t.index ["reverse_key"], name: "index_physical_links_on_reverse_key"
  end

  create_table "physical_manufacturers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "physical_package_class_compositions", force: :cascade do |t|
    t.string "package_class_type", null: false
    t.bigint "package_class_id", null: false
    t.string "component_class_type", null: false
    t.bigint "component_class_id", null: false
    t.string "name_template"
    t.index ["component_class_type", "component_class_id"], name: "physical_composition_component_class_idx"
    t.index ["package_class_type", "package_class_id"], name: "physical_composition_package_class_idx"
  end

  create_table "physical_package_classes", id: false, force: :cascade do |t|
    t.bigint "id", default: -> { "nextval('physical_element_classes_id_seq'::regclass)" }, null: false
    t.string "type"
    t.string "name"
    t.bigint "manufacturer_id"
    t.string "model"
    t.string "part_number"
    t.string "version"
    t.float "width"
    t.float "height"
    t.float "depth"
    t.float "weigth"
    t.bigint "powertype_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "test_package"
  end

  create_table "physical_powertype_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "powertype_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "powertype_desc_idx"
  end

  create_table "physical_powertypes", force: :cascade do |t|
    t.string "name"
    t.string "instance_class_name"
    t.integer "parent_id"
    t.boolean "primary", default: false
    t.index ["parent_id"], name: "physical_parent_powertype_idx"
  end

  create_table "physical_rack_classes", id: false, force: :cascade do |t|
    t.bigint "id", default: -> { "nextval('physical_element_classes_id_seq'::regclass)" }, null: false
    t.string "type"
    t.string "name"
    t.bigint "manufacturer_id"
    t.string "model"
    t.string "part_number"
    t.string "version"
    t.float "width"
    t.float "height"
    t.float "depth"
    t.float "weigth"
    t.bigint "powertype_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "test_package"
    t.string "test_frame"
    t.string "test_rack"
  end

  create_table "physical_slot_classes", id: false, force: :cascade do |t|
    t.bigint "id", default: -> { "nextval('physical_element_classes_id_seq'::regclass)" }, null: false
    t.string "type"
    t.string "name"
    t.bigint "manufacturer_id"
    t.string "model"
    t.string "part_number"
    t.string "version"
    t.float "width"
    t.float "height"
    t.float "depth"
    t.float "weigth"
    t.bigint "powertype_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "test_component"
    t.string "test_connector"
    t.string "test_slot"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags_attachments", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "attachment_type"
    t.bigint "attachment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_type", "attachment_id"], name: "index_tags_attachments_on_attachment"
    t.index ["tag_id"], name: "index_tags_attachments_on_tag_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "time_lists", force: :cascade do |t|
    t.string "name"
    t.integer "tasks_order", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_task_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "task_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "task_desc_idx"
  end

  create_table "time_tasks", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id"
    t.bigint "priority_id"
    t.integer "parent_id"
    t.integer "progress_percentage"
    t.date "due_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority_id"], name: "time_task_priority_idx"
    t.index ["state_id"], name: "time_task_state_idx"
  end

  create_table "url_links", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "attachment_type"
    t.bigint "attachment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_type", "attachment_id"], name: "index_url_links_on_attachment"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "physical_connected_to_associations", "physical_elements", column: "first_element_id"
  add_foreign_key "physical_connected_to_associations", "physical_elements", column: "second_element_id"
  add_foreign_key "physical_connector_hostings", "physical_elements", column: "connector_id"
  add_foreign_key "physical_connector_hostings", "physical_elements", column: "package_id"
  add_foreign_key "physical_elements", "physical_element_classes", column: "element_class_id"
  add_foreign_key "physical_elements", "physical_elements", column: "host_id"
end
