# frozen_string_literal: true

module App
  module Dna
    module Queries
      # Device
      class Devices < ::Queries::BaseQuery
        type [::App::Dna::Types::DeviceType], null: false

        argument :limit, Integer, required: false
        argument :page, Integer, required: false
        argument :hostname, String, required: false
        argument :device_family_ids, [Integer], required: false, default_value: []
        argument :device_platform_id_ids, [Integer], required: false, default_value: []
        argument :device_software_type_ids, [Integer], required: false, default_value: []
        argument :device_series_ids, [Integer], required: false, default_value: []
        argument :device_type_ids, [Integer], required: false, default_value: []
        argument :device_role_ids, [Integer], required: false, default_value: []

        def resolve(
          limit: 100,
          page: 1,
          hostname: nil,
          device_family_ids: nil,
          device_platform_id_ids: nil,
          device_software_type_ids: nil,
          device_series_ids: nil,
          device_type_ids: nil,
          device_role_ids: nil
        )
          scope = ::Dna::Device.includes(
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
              equipements: %i[equipement_type product_id]
            ],
            equipements: %i[equipement_type product_id]
          ).where('hostname LIKE ?', "%#{hostname || ''}%")
          scope = scope.where(device_family_id: device_family_ids) unless device_family_ids.blank?
          scope = scope.where(device_platform_id_id: device_platform_id_ids) unless device_platform_id_ids.blank?
          scope = scope.where(device_software_type_id: device_software_type_ids) unless device_software_type_ids.blank?
          scope = scope.where(device_series_id: device_series_ids)  unless device_series_ids.blank?
          scope = scope.where(device_family_id: device_family_ids)  unless device_family_ids.blank?
          scope = scope.where(device_type_id: device_type_ids)  unless device_type_ids.blank?
          scope = scope.where(device_role_id: device_role_ids)  unless device_role_ids.blank?
          scope.limit(limit).offset(page)
        end
      end
    end
  end
end
