# frozen_string_literal: true

module App
  module Apic
    module Types
      # TenantType
      class TenantType < ::Types::BaseObject
        field :name, String, null: false
        field :L3Outs, [::App::Apic::Types::L3OutType]
        field :application_profiles, [::App::Apic::Types::ApplicationProfileType]
      end
    end
  end
end
