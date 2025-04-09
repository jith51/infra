class CreateDnaTables < ActiveRecord::Migration[7.1]
  def change
    create_table :dna_devices do |t|
      t.string :description
      t.string :software_version
      t.string :mac_address
      t.string :serial_number
      t.string :hostname
      t.string :management_ip
      t.string :location
      t.string :uuid, index: {unique: true}
      t.belongs_to :device_family, null: true, index: true
      t.belongs_to :device_platform_id, null: true, index: true
      t.belongs_to :device_software_type, null: true, index: true
      t.belongs_to :device_series, null: true, index: true
      t.belongs_to :device_type, null: true, index: true
      t.belongs_to :device_role, null: true, index: true
    end

    create_table :dna_device_families do |t|
      t.string :name, index: {unique: true}
    end

    create_table :dna_device_platform_ids do |t|
      t.string :name, index: {unique: true}
    end

    create_table :dna_device_software_types do |t|
      t.string :name, index: {unique: true}
    end

    create_table :dna_device_series do |t|
      t.string :name, index: {unique: true}
    end

    create_table :dna_device_types do |t|
      t.string :name, index: {unique: true}
    end

    create_table :dna_device_roles do |t|
      t.string :name, index: {unique: true}
    end

    create_table :dna_product_ids do |t|
      t.string :name, index: {unique: true}
    end

    create_table :dna_equipements do |t|
      t.string :name
      t.string :description
      t.string :serial_number
      t.string :uuid, index: {unique: true}
      t.belongs_to :product_id, null: true, index: true
      t.belongs_to :equipement_type, null: true, index: true
      t.belongs_to :host, polymorphic: true, null: false, index: true
    end

    create_table :dna_switch_platform_ids do |t|
      t.string :name, index: {unique: true}
    end

    create_table :dna_equipement_types do |t|
      t.string :name, index: {unique: true}
    end

    create_table :dna_switches do |t|
      t.string :uuid
      t.string :description
      t.string :mac_address
      t.string :serial_number
      t.string :role
      t.string :stack_member_number
      t.string :software_image
      t.belongs_to :switch_platform_id, null: true, index: true
      t.belongs_to :equipement_type, null: true, index: true
      t.belongs_to :device, null: true, index: true
    end

    create_table :dna_eol_bulletins do |t|
      t.string :number
      t.string :name
      t.string :eol_type
      t.string :url
      t.date :end_of_life_date
      t.date :last_date_of_support
    end
    add_index :dna_eol_bulletins, [:eol_type, :number], unique: true

    create_table :dna_devices_eol_bulletins, id:false do |t|
      t.belongs_to :device
      t.belongs_to :eol_bulletin
    end
    add_index :dna_devices_eol_bulletins, [:device_id, :eol_bulletin_id], unique: true
  end
end
