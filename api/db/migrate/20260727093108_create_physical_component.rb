# frozen_string_literal: true

# Creation des physical component
class CreatePhysicalComponent < ActiveRecord::Migration[8.1]
  def up
    create_table :physical_component_types do |t|
      t.string :name, null: false, index: true
    end
    create_table :physical_component_slots do |t|
      t.string :name, null: false, index: true
      t.belongs_to :component_type, null: false, foreign_key: {
        to_table: :physical_component_types,
        on_delete: :restrict
      }
      t.belongs_to :chassis_class, null: false, foreign_key: {
        to_table: :physical_chassis_classes,
        on_delete: :cascade
      }
      t.string :description
    end
    create_table :physical_components do |t|
      t.string :name, null: false, index: true
      t.belongs_to :component_type, null: false, foreign_key: {
        to_table: :physical_component_types,
        on_delete: :restrict
      }
      t.belongs_to :chassis, null: false, foreign_key: {
        to_table: :physical_chassis,
        on_delete: :cascade
      }
      t.string :description
      t.string :serial_number
    end
  end

  def down
    drop_table :physical_component_types
    drop_table :physical_component_slots
    drop_table :physical_components
  end
end
