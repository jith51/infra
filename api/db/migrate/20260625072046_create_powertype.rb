# frozen_string_literal: true

# Creation des powertypes
class CreatePowertype < ActiveRecord::Migration[7.1]
  def up
    create_table :powertypes do |t|
      t.integer :parent_id
      t.string :type
      t.string :name
      t.jsonb :custom_attributes_definition, null: false, default: {}
      t.index %I[type name], unique: true
      t.timestamps
    end
  end

  def down
    delete_table :powertypes
  end
end
