# frozen_string_literal: true

module App
  module Apic
    module Types
      # ApForContractableEpgType
      class ApForContractableEpgType < ::Types::BaseObject
        field :name, String, null: false
        field :tenant, ::App::Apic::Types::TenantType
      end
    end
  end
end
