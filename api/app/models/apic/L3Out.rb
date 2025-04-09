class Apic::L3Out <  ActiveRecord::Base
	self.table_name = "apic_L3Out"

	belongs_to :tenant

	has_many :provided_contrats, as: :contractable
	has_many :consumed_contrats, as: :contractable
	has_many :used_contrats, as: :contractable

	has_many :contrats, through: :used_contrats
	has_many :utilised_contrats, through: :consumed_contrats, source: :contrat

	has_and_belongs_to_many :domaines, association_foreign_key: :apic_domaine_id, foreign_key: :apic_L3Out_id
end