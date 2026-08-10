class CreatePhysicalChassis < ActiveRecord::Migration[8.1]
  def change
    create_table :physical_chassis do |t|
      t.belongs_to :chassis_class, null: false, index: true
      t.string :name, null: false, index: { unique: true }
      t.string :serial_number, null: true
      t.jsonb :custom_attributes, default: {}
      t.timestamps
    end
  end
end
