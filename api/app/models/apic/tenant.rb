class Apic::Tenant <  ActiveRecord::Base
  has_many :domaines
  has_many :L3Outs
  has_many :application_profiles
end