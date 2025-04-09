module ApicGql
  module Types
    class TenantType < ::Types::BaseObject
      field :name, String, null: false
      field :L3Outs, [::ApicGql::Types::L3OutType]
      field :application_profiles, [::ApicGql::Types::ApplicationProfileType]
    end
  end
end