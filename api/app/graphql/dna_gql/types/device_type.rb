module DnaGql
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

      field :device_family, ::DnaGql::Types::DeviceFamilyType
      field :device_platform_id, ::DnaGql::Types::DevicePlatformIdType
      field :device_software_type, ::DnaGql::Types::DeviceSoftwareTypeType
      field :device_series, ::DnaGql::Types::DeviceSeriesType
      field :device_type, ::DnaGql::Types::DeviceTypeType
      field :device_role, ::DnaGql::Types::DeviceRoleType

      field :equipements, [::DnaGql::Types::EquipementType]
      field :switches, [::DnaGql::Types::SwitchType]
      field :eol_bulletins, [::DnaGql::Types::EolBulletinType]
    end
  end
end