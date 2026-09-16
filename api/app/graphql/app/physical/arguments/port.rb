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
        argument :mac_address, String, required: false
        argument :port_type_id, ID, required: false
        argument :connection, ::App::Physical::Arguments::Connection, as: :connection_attributes, required: false
        # , prepare: ->(value, _ctx) {
        #   return nil unless value.id.present?
        #   value.to_h.merge!({ _destroy: value.distant_id.blank?, distant_id: value.id })
        # }
      end
    end
  end
end
