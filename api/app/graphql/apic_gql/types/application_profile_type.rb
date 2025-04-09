module ApicGql
  module Types
    class ApplicationProfileType < ::Types::BaseObject
      field :name, String, null: false
      field :tenant, ::ApicGql::Types::TenantType
      field :epgs, [::ApicGql::Types::EpgType], null:true, method: :epgs
    end
  end
end