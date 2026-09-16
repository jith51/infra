# frozen_string_literal: true

module App
  module Apic
    module Types
      # Taches Apic
      class ATaskType < ::Types::BaseObject
        field :name, String, null: false
      end
    end
  end
end
