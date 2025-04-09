module DnaGql
  module Types
    class ProductIdType < ::Types::BaseObject
      field :id, ID, null: false
      field :name, String, null: false
    end
  end
end