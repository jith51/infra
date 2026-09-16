# frozen_string_literal: true

module App
  module Apic
    module Types
      # UsedOutFilterType
      class UsedOutFilterType < ::Types::BaseObject
        field :vzFilter, ::App::Apic::Types::VzFilterType
      end
    end
  end
end
