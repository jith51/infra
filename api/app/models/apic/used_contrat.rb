class Apic::UsedContrat <  ActiveRecord::Base
  belongs_to :contrat
  belongs_to :contractable, polymorphic: true
end