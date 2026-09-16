# frozen_string_literal: true

module App
  module Apic
    module Types
      # UsedFilterType
      class UsedFilterType < ::Types::BaseObject
        field :type, String, null: false
        field :vzFilter, ::App::Apic::Types::VzFilterType
      end
    end
  end
end
