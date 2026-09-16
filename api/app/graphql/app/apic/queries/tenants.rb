# frozen_string_literal: true

module App
  module Apic
    module Queries
      # Tenants
      class Tenants < ::Queries::BaseQuery
        type [::App::Apic::Types::TenantType], null: false

        def resolve
          ::Apic::Tenant.includes(
            L3Outs: {
              used_contrats: [ 
                contrat: { used_filters: :vzFilter }
              ]
            },
            application_profiles: {
              epgs: [
                :serveurs,
                :domaine,
                :domaine_attributs,
                :path_attributs,
                used_contrats: [
                  contrat: {
                    used_contrats: :contractable,
                    used_filters: :vzFilter
                  }
                ]
              ]
            }
          ).order(:name).all
        end
      end
    end
  end
end
