class ApiQueries < Types::BaseObject
  include Concern::ResolverLoader
  
  include GraphQL::Types::Relay::HasNodeField
  include GraphQL::Types::Relay::HasNodesField

  load_query_resolvers_for ApicGql::Queries
  load_query_resolvers_for DnaGql::Queries

  field :user, resolver: Queries::User

end