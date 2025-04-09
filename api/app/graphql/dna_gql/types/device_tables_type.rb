module DnaGql
  module Types
    class DeviceTablesType < ::Types::BaseObject
      field :device_families, [::DnaGql::Types::DeviceFamilyType]
      field :device_platform_ids, [::DnaGql::Types::DevicePlatformIdType]
      field :device_software_types, [::DnaGql::Types::DeviceSoftwareTypeType]
      field :device_series, [::DnaGql::Types::DeviceSeriesType]
      field :device_types, [::DnaGql::Types::DeviceTypeType]
      field :device_roles, [::DnaGql::Types::DeviceRoleType]
    end
  end
end