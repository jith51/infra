class Apic::EpgsPathAttribut<  ActiveRecord::Base
  belongs_to :epg, foreign_key: :apic_epg_id
  belongs_to :path_attribute, foreign_key: :apic_path_attribut_id
end