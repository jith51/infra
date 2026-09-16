# frozen_string_literal: true

module App
  module Apic
    module Queries
      # Contrat
      class Contrats < ::Queries::BaseQuery
        type [::App::Apic::Types::ContratType], null: false

        def resolve
          ::Apic::Contrat.includes(
            used_contrats: {
              contractable: [
                :serveurs,
                # if EPG
                # :domaine, # if EPG
                # :domaine_attributs, # if EPG
                # :path_attributs, # if EPG
                application_profile: :tenant
              ]
            },
            used_filters: :vzFilter
            ).order(:name).all
        end
      end
    end
  end
end
