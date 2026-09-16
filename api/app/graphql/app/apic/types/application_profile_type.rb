# frozen_string_literal: true

module App
  module Apic
    module Types
      # ApplicationProfileType
      class ApplicationProfileType < ::Types::BaseObject
        field :name, String, null: false
        field :tenant, ::App::Apic::Types::TenantType
        field :epgs, [::App::Apic::Types::EpgType], null: true, method: :epgs
      end
    end
  end
end
