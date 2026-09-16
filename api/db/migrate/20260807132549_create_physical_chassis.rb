class CreatePhysicalChassis < ActiveRecord::Migration[8.1]
  def up
    create_table :physical_chassis do |t|
      t.belongs_to :chassis_class, null: false, foreign_key: {
        to_table: :physical_chassis_classes,
        on_delete: :restrict
      }
      t.string :name, null: false, index: { unique: true }
      t.string :serial_number, null: true
      t.jsonb :custom_attributes, null: false, default: {}
      t.timestamps
    end
  end
  def down
    drop_table :physical_chassis
  end
end
