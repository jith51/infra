class Apic::Domaine <  ActiveRecord::Base

	belongs_to :tenant
	
	has_and_belongs_to_many :contexts, association_foreign_key: :apic_context_id, foreign_key: :apic_domaine_id
	has_and_belongs_to_many :L3Outs, association_foreign_key: :apic_L3Out_id, foreign_key: :apic_domaine_id
	has_many :subnets
	has_many :epgs

end