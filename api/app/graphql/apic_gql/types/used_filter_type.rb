module ApicGql
  module Types
    class UsedFilterType < ::Types::BaseObject
      field :type, String, null: false
      field :vzFilter, ::ApicGql::Types::VzFilterType
    end
  end
end