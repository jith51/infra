# frozen_string_literal: true

module App
  module Physical
    module Queries
      # Class générique de dowload de document
      class ChassisFile < ::Queries::BaseQuery
        argument :struct_only, Boolean, required: true
        argument :chassis_class_id, ID, required: false

        type ::Types::FileUrlType, null: false

        def resolve(struct_only:, chassis_class_id: nil)
          # Construction du fichier
          content = ::Excel::Chassis::Export.new(
            struct_only: struct_only,
            chassis_class_id: chassis_class_id
          ).build
          # Envoi du fichier
          {
            filename: 'chassis.xlsx',
            type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            content_base64: Base64.strict_encode64(content)
          }
        end
      end
    end
  end
end
