class Apic::DomaineAttributsEpg <  ActiveRecord::Base
  belongs_to :epg, foreign_key: :apic_epg_id
  belongs_to :domaine_attribute, foreign_key: :apic_domaine_attribut_id   
end