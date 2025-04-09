class Apic::VzFilter <  ActiveRecord::Base
	self.table_name = "apic_vzFilter"

	belongs_to :tenant

	has_many :used_filters, foreign_key: :vzFilter_id
	has_many :contrats, through: :used_filters
end