class Dna::Equipement <  ActiveRecord::Base
  belongs_to :host, polymorphic: true
  belongs_to :product_id
  belongs_to :equipement_type
end