# frozen_string_literal: true

module App
  module Dna
    module Types
      class DeviceTablesType < ::Types::BaseObject
        field :device_families, [::App::Dna::Types::DeviceFamilyType]
        field :device_platform_ids, [::App::Dna::Types::DevicePlatformIdType]
        field :device_software_types, [::App::Dna::Types::DeviceSoftwareTypeType]
        field :device_series, [::App::Dna::Types::DeviceSeriesType]
        field :device_types, [::App::Dna::Types::DeviceTypeType]
        field :device_roles, [::App::Dna::Types::DeviceRoleType]
      end
    end
  end
end
