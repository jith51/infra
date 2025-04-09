module AuthGql
  module Types
    class MutationType < ::Types::BaseObject
      field :user_cas_login, mutation: ::AuthGql::Mutations::UserCasLogin
      # field :user_login, mutation: ::AuthGql::Mutations::UserLogin
      field :user_logout, mutation: ::AuthGql::Mutations::UserLogout
    end
  end
end
