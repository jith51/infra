# frozen_string_literal: true

module App
  module Physical
    module Queries
      # ChassisPowertype
      class ChassisPowertype < ::Queries::BaseQuery
        argument :name, String, required: true

        type ::App::Physical::Types::ChassisPowertype, null: false

        def resolve(name:)
          ::Physical::ChassisPowertype.find_by('id::text = :value OR name = :value', value: name)
        end
      end
    end
  end
end
