# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # ChassisArguments
      class Chassis < ::Types::BaseInputObject
        graphql_name 'ChassisInput'

        argument :id, ID, required: false
        argument :name, String, required: true
        argument :serial_number, String, required: false
        argument :chassis_class_id, ID, required: true
        argument :ports, [::App::Physical::Arguments::Port], as: :ports_attributes, required: false, prepare: ->(value, _ctx) { value.map(&:to_h) }
        argument :components, [::App::Physical::Arguments::Component], as: :components_attributes, required: false, prepare: ->(value, _ctx) { value.map(&:to_h) }
        argument :custom_attributes, GraphQL::Types::JSON, required: false
        argument :tag_ids, [ID], required: false
      end
    end
  end
end
