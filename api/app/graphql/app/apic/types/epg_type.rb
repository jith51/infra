# frozen_string_literal: true

module App
  module Apic
    module Types
      # EpgType
      class EpgType < ::Types::BaseObject
        implements ::App::Apic::Types::Interface::BaseContractable

        field :domaine, ::App::Apic::Types::DomaineType
        field :domaine_attributs, [::App::Apic::Types::DomaineAttributType]
        field :path_attributs, [::App::Apic::Types::PathAttributType]
        field :serveurs, [::App::Apic::Types::ServeurType]
        field :application_profile, ::App::Apic::Types::ApplicationProfileType
      end
    end
  end
end
