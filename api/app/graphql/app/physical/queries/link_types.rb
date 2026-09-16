# frozen_string_literal: true

module App
  module Physical
    module Queries
      # LinkTypes
      class LinkTypes < ::Queries::BaseQuery
        type [::App::Physical::Types::LinkType], null: false

        def resolve
          ::Physical::LinkType.all
        end
      end
    end
  end
end
