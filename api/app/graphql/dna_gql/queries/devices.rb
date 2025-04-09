
module DnaGql
  module Queries
    class Devices < ::Queries::BaseQuery
      graphql_name 'devices'

      type [::DnaGql::Types::DeviceType], null: false
      
      argument :_limit, Integer, required: false
      argument :_page, Integer, required: false
      argument :hostname, String, required: false
      argument :device_family_ids, [Integer], required: false, default_value: []
      argument :device_platform_id_ids, [Integer], required: false, default_value: []
      argument :device_software_type_ids, [Integer], required: false, default_value: []
      argument :device_series_ids, [Integer], required: false, default_value: []
      argument :device_type_ids, [Integer], required: false, default_value: []
      argument :device_role_ids, [Integer], required: false, default_value: []

      def resolve(
        _limit: nil,
        _page: nil,
        hostname: nil,
        device_family_ids: nil,
        device_platform_id_ids: nil,
        device_software_type_ids: nil,
        device_series_ids: nil,
        device_type_ids: nil,
        device_role_ids: nil
      )
        ::Dna::Device.includes(
          :eol_bulletins,
          :device_family,
          :device_platform_id,
          :device_software_type,
          :device_series,
          :device_type,
          :device_role,
          switches: [
            :switch_platform_id,
            :equipement_type,
            equipements: [
              :equipement_type,
              :product_id
            ]
          ],
          equipements: [
            :equipement_type,
            :product_id
          ]
        ).where(
          where_clause(
            hostname,
            device_family_ids,
            device_platform_id_ids,
            device_software_type_ids,
            device_series_ids,
            device_type_ids,
            device_role_ids
          )
        ).limit(_limit||1).offset(_page||1)
      end
      private

      def where_clause(
        hostname,
        device_family_ids,
        device_platform_id_ids,
        device_software_type_ids,
        device_series_ids,
        device_type_ids,
        device_role_ids
        )

        where_clause = ["dna_devices.hostname LIKE '%#{hostname||""}%'"]

        if device_family_ids.length != 0
          where_clause << "dna_devices.device_family_id = ANY('{#{device_family_ids.join(',')}}'::int[])"
        end

        if device_platform_id_ids.length != 0
          where_clause << "dna_devices.device_platform_id_id = ANY('{#{device_platform_id_ids.join(',')}}'::int[])"
        end

        if device_software_type_ids.length != 0
          where_clause << "dna_devices.device_software_type_id = ANY('{#{device_software_type_ids.join(',')}}'::int[])"
        end

        if device_series_ids.length != 0
          where_clause << "dna_devices.device_series_id = ANY('{#{device_series_ids.join(',')}}'::int[])"
        end

        if device_type_ids.length != 0
          where_clause << "dna_devices.device_type_id = ANY('{#{device_type_ids.join(',')}}'::int[])"
        end

        if device_role_ids.length != 0
          where_clause << "dna_devices.device_role_id = ANY('{#{device_role_ids.join(',')}}'::int[])"
        end

        return where_clause.join(' and ')

      end
    end
  end
end