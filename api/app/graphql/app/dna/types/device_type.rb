# frozen_string_literal: true

module App
  module Dna
    module Types
      class DeviceType < ::Types::BaseObject
        field :id, ID, null: false
        field :software_version, String, null: true
        field :uuid, String, null: true
        field :description, String, null: true
        field :mac_address, String, null: true
        field :serial_number, String, null: true
        field :role, String, null: true
        field :hostname, String, null: true
        field :management_ip, String, null: true
        field :location, String, null: true

        field :device_family, ::App::Dna::Types::DeviceFamilyType
        field :device_platform_id, ::App::Dna::Types::DevicePlatformIdType
        field :device_software_type, ::App::Dna::Types::DeviceSoftwareTypeType
        field :device_series, ::App::Dna::Types::DeviceSeriesType
        field :device_type, ::App::Dna::Types::DeviceTypeType
        field :device_role, ::App::Dna::Types::DeviceRoleType

        field :equipements, [::App::Dna::Types::EquipementType]
        field :switches, [::App::Dna::Types::SwitchType]
        field :eol_bulletins, [::App::Dna::Types::EolBulletinType]
      end
    end
  end
end
