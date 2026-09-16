# frozen_string_literal: true

# Creation des physical port
class CreatePhysicalPort < ActiveRecord::Migration[8.1]
  def up
    create_table :physical_port_types do |t|
      t.string :name, null: false, index: true
    end
    create_table :physical_port_slots do |t|
      t.string :name, null: false, index: true
      t.belongs_to :port_type, null: true, foreign_key: {
        to_table: :physical_port_types,
        on_delete: :restrict
      }
      t.belongs_to :chassis_class, null: false, foreign_key: {
        to_table: :physical_chassis_classes,
        on_delete: :cascade
      }
      t.string :description
    end
    create_table :physical_ports do |t|
      t.string :name, null: false, index: true
      t.belongs_to :port_type, null: false, foreign_key: {
        to_table: :physical_port_types,
        on_delete: :restrict
      }
      t.belongs_to :chassis, null: false, foreign_key: {
        to_table: :physical_chassis,
        on_delete: :cascade
      }
      t.string :mac_address
      t.string :description
    end
  end

  def down
    drop_table :physical_port_types
    drop_table :physical_port_slots
    drop_table :physical_ports
  end
end
