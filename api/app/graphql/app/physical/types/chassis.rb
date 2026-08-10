# frozen_string_literal: true

module App
  module Physical
    module Types
      # ChassisType
      class Chassis < ::Types::BaseObject
        graphql_name 'ChassisType'

        field :id, ID, null: false
        field :name, String, null: false
        field :serial_number, String, null: true
        field :chassis_class_id, String, null: false
        field :chassis_class, ::App::Physical::Types::ChassisClass
        field :ports, [::App::Physical::Types::Port]
        field :components, [::App::Physical::Types::Component]
        field :custom_attributes, GraphQL::Types::JSON, null: false
        field :tag_ids, [ID]
        field :tags, [String]

        def tags
          object.tags.map(&:name)
        end
      end
    end
  end
end
