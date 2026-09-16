# frozen_string_literal: true

module Physical
  # Composant
  class Component < ActiveRecord::Base
    belongs_to :component_type, required: false
    belongs_to :chassis
    validates :name, presence: true, uniqueness: { scope: :chassis_id }
  end
end
