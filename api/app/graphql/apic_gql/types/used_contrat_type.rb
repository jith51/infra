module ApicGql
  module Types
    class UsedContratType < ::Types::BaseObject
      field :type, String, null: false
      # field :contractable, String, null: false
      field :contrat, ::ApicGql::Types::ContratType
      field :contractable, ::ApicGql::Types::Interface::BaseContractable, null: false
    end
  end
end