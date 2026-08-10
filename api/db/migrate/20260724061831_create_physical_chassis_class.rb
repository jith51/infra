# frozen_string_literal: true

# Creation des powertchassi class
class CreatePhysicalChassisClass < ActiveRecord::Migration[8.1]
  def change
    create_table :physical_chassis_classes do |t|
      t.string :name, null: false, index: { unique: true }
      t.belongs_to :chassis_powertype, index: true
      t.string :fournisseur
      t.string :model
      t.string :part_number
      t.string :vendor_equipment_type
      t.string :version
      t.string :url_link
      t.integer :height
      t.jsonb :custom_attributes, default: {}
      t.jsonb :custom_attributes_definition, default: {}
      t.timestamps
    end
  end
end
