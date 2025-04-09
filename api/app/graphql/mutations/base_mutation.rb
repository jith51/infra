module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation 
    # GraphQL::Schema::RelayClassicMutation  --> ajoute automatiquement input: {}
    # < GraphQL::Schema::Mutation pour ne pas avoir l'input
    argument_class Types::BaseArgument
    field_class Types::BaseField
    # input_object_class Types::BaseInputObject
    object_class Types::BaseObject
  end
end
