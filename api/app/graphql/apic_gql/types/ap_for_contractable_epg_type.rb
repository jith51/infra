module ApicGql
  module Types
    class ApForContractableEpgType < ::Types::BaseObject
      field :name, String, null: false
      field :tenant, ::ApicGql::Types::TenantType
    end
  end
end