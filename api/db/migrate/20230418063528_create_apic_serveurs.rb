class CreateApicServeurs < ActiveRecord::Migration[7.0]
  def change
    create_table "apic_serveurs", force: :cascade do |t|
      t.string "name", null: false
      t.integer "epg_id", null: false
      t.integer "powerstate"
      t.string "os"
      t.index ["epg_id"], name: "index_apic_serveurs_on_epg_id"
      t.index ["name"], name: "index_apic_serveurs_on_name"
    end
  end
end
