# frozen_string_literal: true

# Queries
class ApiQueries < Types::BaseObject
  include Concern::ResolverLoader
  include GraphQL::Types::Relay::HasNodeField
  include GraphQL::Types::Relay::HasNodesField

  load_query_resolvers_for ::App::Apic::Queries
  load_query_resolvers_for ::App::Dna::Queries
  load_query_resolvers_for ::App::Common::Queries
  load_query_resolvers_for ::App::Physical::Queries
  # load_query_resolvers_for IndicateurGql::Queries

  # field :user, resolver: Queries::User
  field :check_auth, resolver: ::App::Auth::Queries::CheckAuth
  # field :other_tags, resolver: App::Common::Queries::Tags
  # field :tags_with_counter, resolver: Queries::TagsWithCounter
end
