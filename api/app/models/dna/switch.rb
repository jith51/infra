class Dna::Switch <  ActiveRecord::Base
  belongs_to :device
  belongs_to :switch_platform_id
  belongs_to :equipement_type
  has_many :equipements, as: :host
end