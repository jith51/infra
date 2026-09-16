# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # LinkTypeArgument
      class LinkType < ::Types::BaseInputObject
        graphql_name 'LinkTypeInput'

        argument :id, ID, required: false
        argument :name, String, required: true
      end
    end
  end
end
