# frozen_string_literal: true

module App
  module Apic
    module Types
      # ConsumedContratType
      class ConsumedContratType < ::Types::BaseObject
        field :contrat, ::App::Apic::Types::ContratType
      end
    end
  end
end
