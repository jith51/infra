# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # ConnectionArguments
      class Connection < ::Types::BaseInputObject
        graphql_name 'ConnectionInput'
        argument :id, ID, required: false
        argument :distant_port_id, ID, required: true
        argument :link_type_id, ID, required: false
      end
    end
  end
end
