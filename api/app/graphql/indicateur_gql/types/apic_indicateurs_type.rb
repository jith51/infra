module IndicateurGql
  module Types
    class ApicIndicateursType < ::Types::BaseObject
      field :nombre_app_profiles, Int, null: true
      field :nombre_app_profiles_avec_legacy, Int, null: true
    end
  end
end