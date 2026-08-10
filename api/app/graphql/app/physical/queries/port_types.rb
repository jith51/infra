# frozen_string_literal: true

module App
  module Physical
    module Queries
      # PortTypes
      class PortTypes < ::Queries::BaseQuery
        type [::App::Physical::Types::PortType], null: false

        def resolve
          ::Physical::PortType.all
        end
      end
    end
  end
end
