module ApicGql
  module Types
    class EpgType < ::Types::BaseObject
      implements ::ApicGql::Types::Interface::BaseContractable

      field :domaine, ::ApicGql::Types::DomaineType
      field :domaine_attributs, [::ApicGql::Types::DomaineAttributType]
      field :path_attributs, [::ApicGql::Types::PathAttributType]
      field :serveurs, [::ApicGql::Types::ServeurType]
      field :application_profile, ::ApicGql::Types::ApplicationProfileType
    end
  end
end