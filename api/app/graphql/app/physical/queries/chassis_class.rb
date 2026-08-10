# frozen_string_literal: true

module App
  module Physical
    module Queries
      # ChassisClass
      class ChassisClass < ::Queries::BaseQuery
        type ::App::Physical::Types::ChassisClass, null: true

        argument :name_or_id, String, required: false

        def resolve(name_or_id: nil)
          return nil if name_or_id.blank?

          ::Physical::ChassisClass
            .includes(:components, :ports)
            .find_by('id::text = :value OR name = :value', value: name_or_id)
        end
      end
    end
  end
end
