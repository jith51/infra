# frozen_string_literal: true

module Physical
  # Composant Slot
  class ComponentSlot < ActiveRecord::Base
    belongs_to :component_type, required: false
    belongs_to :chassis_class
    validates :name, presence: true, uniqueness: { scope: :chassis_class_id }
  end
end
