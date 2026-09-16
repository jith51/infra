# frozen_string_literal: true

module App
  module Apic
    module Types
      # UsedContratType
      class UsedContratType < ::Types::BaseObject
        field :type, String, null: false
        # field :contractable, String, null: false
        field :contrat, ::App::Apic::Types::ContratType
        field :contractable, ::App::Apic::Types::Interface::BaseContractable, null: false
      end
    end
  end
end
