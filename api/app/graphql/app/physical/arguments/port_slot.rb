# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # PortSlotArguments
      class PortSlot < ::Types::BaseInputObject
        graphql_name 'PortSlotInput'

        argument :id, ID, required: false
        argument :name, String, required: true
        argument :description, String, required: false
        argument :port_type_id, ID, required: false
      end
    end
  end
end
