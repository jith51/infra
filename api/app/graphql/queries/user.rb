module Queries
    class User < Queries::BaseQuery
        type Types::UserType, null: false
        def resolve()
            { id: context[:current_user] }
        end
    end
end