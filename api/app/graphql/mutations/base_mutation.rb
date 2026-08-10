# frozen_string_literal: true

module Mutations
  # BaseMutation
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    # GraphQL::Schema::RelayClassicMutation  --> ajoute automatiquement input: {}
    # < GraphQL::Schema::Mutation pour ne pas avoir l'input
    argument_class Types::BaseArgument
    field_class Types::BaseField
    # input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def baseResolver(klass, args)
      object = args[:id].blank? ? klass.new : klass.find(args[:id])

      object.assign_attributes(args)

      object.save!

      object
    end
  end
end
