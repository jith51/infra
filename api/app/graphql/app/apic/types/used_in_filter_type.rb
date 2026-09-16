# frozen_string_literal: true

module App
  module Apic
    module Types
      # USedINFilterTypes
      class UsedInFilterType < ::Types::BaseObject
        field :vzFilter, ::App::Apic::Types::VzFilterType
      end
    end
  end
end
