class Apic::Epg <  ActiveRecord::Base

	belongs_to :application_profile
	belongs_to :domaine

	has_many :serveurs

	has_many :provided_contrats, as: :contractable
	has_many :consumed_contrats, as: :contractable
	has_many :used_contrats, as: :contractable

	has_and_belongs_to_many :domaine_attributs, association_foreign_key: :apic_domaine_attribut_id, foreign_key: :apic_epg_id
	has_and_belongs_to_many :path_attributs, association_foreign_key: :apic_path_attribut_id, foreign_key: :apic_epg_id

	def self.WithOutServeur 
		toto = []
		Apic::Epg.joins(:application_profile).map do |epg|
			toto << {epg: epg.name, ap: epg.application_profile.name } if epg.serveurs.count == 0
		end
		return toto
	end
end