module IndicateurGql
  module Queries
    class ApicIndicateurs < ::Queries::BaseQuery
      graphql_name 'apic_indicateurs'

      type ::IndicateurGql::Types::ApicIndicateursType, null: false
      
      def resolve()
        
        nombre_app_profiles = Apic::ApplicationProfile.count + 1 # +1 pour le L3OUT

        nombre_app_profiles_avec_legacy = Apic::Contrat.find_by(name: 'LEGACY').used_contrats.includes(contractable: :application_profile).map do |used_contrat|
            return used_contrat.contractable_type == "Apic::Epg" ? used_contrat.contractable.application_profile.name :  "L3OUT"
        end.uniq().count

        return {
          nombre_app_profiles: nombre_app_profiles,
          nombre_app_profiles_avec_legacy: nombre_app_profiles_avec_legacy
        }
      end
    end
  end
end