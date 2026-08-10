# frozen_string_literal: true

# Creation des physical component
class CreatePhysicalComponent < ActiveRecord::Migration[8.1]
  def change
    create_table :physical_components do |t|
      t.string :name, null: false, index: true
      t.belongs_to :component_type
      t.belongs_to :host, polymorphic: true
      t.string :description
      t.string :serial_number
    end
    create_table :physical_component_types do |t|
      t.string :name, null: false, index: true
    end
  end
end
