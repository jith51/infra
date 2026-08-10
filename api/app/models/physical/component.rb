# frozen_string_literal: true

module Physical
  # Composant
  class Component < ActiveRecord::Base
    belongs_to :component_type, required: false
    belongs_to :host, polymorphic: true
    validates :name, presence: true, uniqueness: { scope: %i[host_id host_type] }
  end
end
