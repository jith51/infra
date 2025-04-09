
module DnaGql
  module Queries
    class DeviceTables < ::Queries::BaseQuery
      graphql_name 'device_tables'

      type ::DnaGql::Types::DeviceTablesType, null: false
      
      def resolve()
        {
          device_families: ::Dna::DeviceFamily.with_number_of_devices,
          device_platform_ids: ::Dna::DevicePlatformId.with_number_of_devices,
          device_software_types: ::Dna::DeviceSoftwareType.with_number_of_devices,
          device_series: ::Dna::DeviceSeries.with_number_of_devices,
          device_types: ::Dna::DeviceType.with_number_of_devices,
          device_roles: ::Dna::DeviceRole.with_number_of_devices
        }
      end
    end
  end
end