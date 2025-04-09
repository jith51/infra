class Apic::Contrat <  ActiveRecord::Base

	belongs_to :tenant

	has_many :used_filters
	has_many :vzFilters, through: :used_filters
	
	has_many :used_in_filters
	has_many :used_out_filters
	has_many :used_sub_filters

	has_many :provided_contrats
	has_many :consumed_contrats
	has_many :used_contrats
end