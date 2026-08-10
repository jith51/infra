# frozen_string_literal: true

module Physical
  # Type de component
  class ComponentType < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true
  end
end
