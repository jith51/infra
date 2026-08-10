# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # PortArguments
      class Port < ::Types::BaseInputObject
        graphql_name 'PortInput'

        argument :id, ID, required: false
        argument :name, String, required: true
        argument :description, String, required: false
        # argument :mac_address, String, required: false
        argument :port_type_id, ID, required: false
        # argument :connection, ::App::Physical::Types::Arguments::Connection, as: :connection_attributes, required: false

        # def prepare
        #   {
        #     id: id,
        #     name: name,
        #     description: description,
        #     # mac_address: mac_address,
        #     port_type_id: port_type_id
        #   }
        # end
      end
    end
  end
end
