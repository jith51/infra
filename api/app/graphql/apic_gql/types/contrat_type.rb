module ApicGql
  module Types
    class ContratType < ::Types::BaseObject
      field :id, ID, null: false
      field :name, String, null: false
      field :used_in_filters, [::ApicGql::Types::UsedInFilterType]
      field :used_filters, [::ApicGql::Types::UsedFilterType]
      field :used_sub_filters, [::ApicGql::Types::UsedSubFilterType]
      field :used_out_filters, [::ApicGql::Types::UsedOutFilterType]
      field :used_contrats, [::ApicGql::Types::UsedContratType]
    end
  end
end