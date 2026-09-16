# frozen_string_literal: true

module App
  module Apic
    module Types
      # ContratType
      class ContratType < ::Types::BaseObject
        field :id, ID, null: false
        field :name, String, null: false
        field :used_in_filters, [::App::Apic::Types::UsedInFilterType]
        field :used_filters, [::App::Apic::Types::UsedFilterType]
        field :used_sub_filters, [::App::Apic::Types::UsedSubFilterType]
        field :used_out_filters, [::App::Apic::Types::UsedOutFilterType]
        field :used_contrats, [::App::Apic::Types::UsedContratType]
      end
    end
  end
end
