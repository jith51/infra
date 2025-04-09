class Apic::L3OutDomaine <  ActiveRecord::Base
  self.table_name = "apic_L3Out_domaines"

	belongs_to :domaine, foreign_key: :apic_domaine_id
  belongs_to :L3Out, foreign_key: :apic_L3Out_id

end