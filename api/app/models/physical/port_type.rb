# frozen_string_literal: true

module Physical
  # Type de port
  class PortType < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true
  end
end
