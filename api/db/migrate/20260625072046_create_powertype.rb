# frozen_string_literal: true

# Creation des powertypes
class CreatePowertype < ActiveRecord::Migration[7.1]
  def change
    create_table :powertypes do |t|
      t.integer :parent_id
      t.string :type
      t.string :name
      t.jsonb :custom_attributes, default: {}
      t.index %I[type name], unique: true
      t.timestamps
    end

    create_table :physical_chassis_classes do |t|
      t.belongs_to :powertype, null: false, index: true, polymorphic: true
      t.string :name, null: false, index: { unique: true }
      t.string :fournisseur
      t.string :model
      t.string :part_number
      t.string :vendor_equipment_type
      t.string :version
      t.string :url_link
      t.integer :height
      t.timestamps
    end
  end
end
