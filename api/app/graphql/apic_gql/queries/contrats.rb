module ApicGql
  module Queries
    class Contrats <  ::Queries::BaseQuery
      graphql_name 'contrats'

      type [::ApicGql::Types::ContratType], null: false
      
      def resolve()
        ::Apic::Contrat.includes(
          used_contrats: [
            contractable: [
              :serveurs, # if EPG
              # :domaine, # if EPG
              # :domaine_attributs, # if EPG
              # :path_attributs, # if EPG
              application_profile: :tenant
            ]
          ],
          used_filters: :vzFilter
          ).order(:name).all


      #   application_profiles = ::Apic::ApplicationProfile.order(:name).all.records
      #   tenants = ::Apic::Tenant.all
      #   epgs = ::Apic::Epg.all
      #   used_in_filters = = ::Apic::UsedInFilter.all
      #   used_out_filters = = ::Apic::UsedOutFilter.all
      #   used_sub_filters = = ::Apic::UsedOutFilter.all
      #   filters = ::Apic::Filter.all
      #   contrats = ::Apic::Contrat.all
      #   used_contrats = ::Apic::UsedContrat.all

      #   # def instance_variables_hash
      #   #   Hash[instance_variables.map { |name| [name, instance_variable_get(name)] } ]
      #   # end

      # #   search_id = -> (arr, name, tenant_id = nil) { 
      # #   arr.filter_map { |c| c.id if c.name == name && (tenant_id.nil? ? true : c.tenant_id == tenant_id) }
      # # }

      # h.store(:key, "bar")


      #   result = application_profiles.map do |application_profile|
      #     {
      #       name: application_profile.name,
      #       tenant: tenants.find { |t| t.id == application_profile.tenant_id },
      #       epgs: epgs.filter_map { |epg|
      #         {
      #           name: epg.name,
      #           provided_contrats: used_contrats.filter_map { |provided_contrat|
      #             {
      #               contrats: contrats.filter_map { |contrat| c.id == provided_contrat.contrat_id 
      #                 {
      #                   name: contrat.name,
      #                   used_in_filters: used_in_filters.filter_map { |used_in_filter|
      #                     {
      #                       vzFilter: filters.find { |f| f.id == used_in_filter.vz_filter_id },
      #                     } if used_in_filter.contrat_id = contrat.id
      #                   },
      #                   used_out_filters: used_in_filters.filter_map { |used_out_filter|
      #                     {
      #                       vzFilter: filters.find { |f| f.id == used_out_filter.vz_filter_id },
      #                     } if used_out_filter.contrat_id = contrat.id
      #                   },
      #                   used_sub_filters: used_in_filters.filter_map { |used_sub_filter|
      #                     {
      #                       vzFilter: filters.find { |f| f.id == used_in_filter.vz_filter_id },
      #                     } if used_sub_filter.contrat_id = contrat.id
      #                   },
      #                   used_contrats: used_contrats { |consumed_contrat|
      #                     {
      #                       contractable: epgs.filter_map { |epg_two|
      #                         {

      #                         } if (
      #                           consumed_contrat.contractable_type ==  "Apic::Epg" && 
      #                           consumed_contrat.contractable_id == epg.id
      #                         )
      #                       }
      #                     } if (
      #                       consumed_contrat.type == "Apic::ConsumedContrat" && 
      #                       consumed_contrat.contrat_id == contrat.id
      #                     )
      #                   }
      #                 }
      #               }
      #             } if ( 
      #               provided_contrat.type == "Apic::ProvidedContrat" && 
      #               provided_contrat.contractable_type ==  "Apic::Epg" && 
      #               provided_contrat.contractable_id == epg.id
      #             )
      #           }
      #         }
      #       }
      #     }
      #   end

      end
    end
  end
end
