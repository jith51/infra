module DnaGql
  module Types
    class EolBulletinType < ::Types::BaseObject
      field :number, String, null: true
      field :name, String, null: true
      field :eol_type, String, null: true
      field :url, String, null: true
      field :end_of_life_date, GraphQL::Types::ISO8601DateTime, null: true
      field :last_date_of_support, GraphQL::Types::ISO8601DateTime, null: true
    end
  end
end