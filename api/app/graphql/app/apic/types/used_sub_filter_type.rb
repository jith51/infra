# frozen_string_literal: true

module App
  module Apic
    module Types
      # UsedSubFilterType
      class UsedSubFilterType < ::Types::BaseObject
        field :vzFilter, ::App::Apic::Types::VzFilterType
      end
    end
  end
end
