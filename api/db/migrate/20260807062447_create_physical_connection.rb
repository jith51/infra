# frozen_string_literal: true

# Creation des connections
class CreatePhysicalConnection < ActiveRecord::Migration[8.1]
  def change
    create_table :physical_link_types do |t|
      t.string :name, null: false, index: true
    end
    create_table :physical_connections do |t|
      t.integer 'local_id', null: false
      t.integer 'distant_id', null: false
      t.belongs_to :link_type
    end
  end
end
