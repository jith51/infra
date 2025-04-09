module ApicGql
  module Types
    class DomaineType < ::Types::BaseObject
      field :name, String, null: false
      field :contexts, [::ApicGql::Types::ContextType]
      field :L3Outs, [::ApicGql::Types::L3OutType]
    end
  end
end