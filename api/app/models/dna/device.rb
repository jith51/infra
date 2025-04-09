class Dna::Device <  ActiveRecord::Base
  belongs_to :device_family, optional: true
  belongs_to :device_platform_id, optional: true
  belongs_to :device_role, optional: true
  belongs_to :device_series, optional: true
  belongs_to :device_software_type, optional: true
  belongs_to :device_type, optional: true
  
  has_and_belongs_to_many :eol_bulletins
  has_many :equipements, as: :host
  has_many :switches
end