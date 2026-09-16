# frozen_string_literal: true

# Mutations
class ApiMutations < Types::BaseObject
  include Concern::ResolverLoader

  load_mutation_resolvers_for ::App::Physical::Mutations

  load_mutation_resolvers_for ::App::Common::Mutations
  # field :tag, mutation: Mutations::Tag
end
