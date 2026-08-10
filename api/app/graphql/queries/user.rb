module Queries
    class User < Queries::BaseQuery
        type Types::UserType, null: false
        def resolve()
            puts 'DDDDDD'
            puts 'DDDDDD'
            puts 'DDDDDD'
            puts 'DDDDDD'
            puts 'DDDDDD'
            puts 'DDDDDD'
            puts 'DDDDDD'
            puts 'DDDDDD'
            { id: context[:current_user] }
        end
    end
end