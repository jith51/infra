# frozen_string_literal: true

module App
  module Physical
    module Queries
      # ComponentTypes
      class ComponentTypes < ::Queries::BaseQuery
        type [::App::Physical::Types::ComponentType], null: false

        def resolve
          ::Physical::ComponentType.all
        end
      end
    end
  end
end
