module ApicGql
  module Types
    class ServeurType < ::Types::BaseObject
      field :name, String, null: false
      field :powerstate, Integer, null: false
      field :os, String 
      # , null: false
    end
  end
end