# frozen_string_literal: true

# Creation des physical port
class CreatePhysicalPort < ActiveRecord::Migration[8.1]
  def change
    create_table :physical_port_types do |t|
      t.string :name, null: false, index: true
    end
    create_table :physical_ports do |t|
      t.string :name, null: false, index: true
      t.belongs_to :port_type
      t.belongs_to :host, polymorphic: true
      t.string :mac_address
      t.string :description
    end
  end
end
