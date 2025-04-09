class Apic::ApplicationProfile <  ActiveRecord::Base

	belongs_to :tenant
	has_many :epgs
end