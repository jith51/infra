# frozen_string_literal: true

# Creation des powertchassi class
class CreatePhysicalChassisClasses < ActiveRecord::Migration[8.1]
  def up
    create_table :physical_chassis_classes do |t|
      t.belongs_to :chassis_powertype, index: true, foreign_key: {
        to_table: :powertypes,
        on_delete: :restrict
      }
      t.string :name, null: false, index: { unique: true }
      t.string :fournisseur
      t.string :model
      t.string :part_number
      t.string :vendor_equipment_type
      t.string :version
      t.string :url_link
      t.integer :height
      t.jsonb :custom_attributes, null: false, default: {}
      t.jsonb :custom_attributes_definition, null: false, default: {}
      t.timestamps
    end
  end
  def down
     drop_table :physical_chassis_classes
  end
end
