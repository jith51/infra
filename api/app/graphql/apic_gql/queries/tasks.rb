module ApicGql
  module Queries
    class Tasks <  ::Queries::BaseQuery
      graphql_name 'tasks'
      type [::ApicGql::Types::ATaskType], null: false
      
      def resolve()
        ::Apic::Task.all
      end
    end
  end
end
