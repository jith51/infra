class Apic::Context <  ActiveRecord::Base
	belongs_to :tenant

	has_many :provided_contrats, as: :contractable
	has_many :consumed_contrats, as: :contractable
	has_many :used_contrats, as: :contractable

end