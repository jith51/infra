# frozen_string_literal: true

module App
  module Physical
    module Queries
      # Class générique de dowload de document
      class ChassisClassesFile < ::Queries::BaseQuery
        argument :struct_only, Boolean, required: true
        argument :chassis_powertype_id, ID, required: false

        type ::Types::FileUrlType, null: false

        def resolve(struct_only:, chassis_powertype_id: nil)
          # Construction du fichier
          content = ::Excel::ChassisClass::Export.new(
            struct_only: struct_only,
            chassis_powertype_id: chassis_powertype_id
          ).build
          # Envoi du fichier
          {
            filename: 'chassis_classes.xlsx',
            type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            content_base64: Base64.strict_encode64(content)
          }
        end
      end
    end
  end
end
