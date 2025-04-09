
class Apic::ContextsDomaine <  ActiveRecord::Base

	belongs_to :domaine, foreign_key: :apic_domaine_id
  belongs_to :context, foreign_key: :apic_context_id

end