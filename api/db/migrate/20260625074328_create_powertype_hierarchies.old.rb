# frozen_string_literal: true

# Creation des powertypes
class CreatePowertypeHierarchies < ActiveRecord::Migration[7.1]
  def up
    create_table :powertype_hierarchies, id: false do |t|
      t.references :ancestor, null: false, foreign_key: {
        to_table: :powertypes, on_delete: :cascade
      }
      t.references :descendant, null: false, foreign_key: {
        to_table: :powertypes, on_delete: :cascade
      }
      t.integer :generations, null: false
      t.index %i[ancestor_id descendant_id generations], unique: true, name: 'powertype_anc_desc_idx'
      t.index :descendant_id, name: 'powertype_desc_idx'
    end
  end

  def down
    drop_table :powertype_hierarchies
  end
end
