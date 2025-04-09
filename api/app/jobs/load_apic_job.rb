class LoadApicJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Apic::Task.delete_all
    Apic::UsedFilter.delete_all
    Apic::VzFilter.delete_all
    Apic::UsedContrat.delete_all
    Apic::Contrat.delete_all
    Apic::L3OutDomaine.delete_all
    Apic::L3Out.delete_all
    Apic::ContextsDomaine.delete_all
    Apic::Context.delete_all
    Apic::Domaine.delete_all
    Apic::Subnet.delete_all
    Apic::DomaineAttributsEpg.delete_all
    Apic::DomaineAttribut.delete_all
    Apic::EpgsPathAttribut.delete_all
    Apic::PathAttribut.delete_all
    Apic::Epg.delete_all
    Apic::ApplicationProfile.delete_all
    Apic::Tenant.delete_all
    

    # Creation d'un lambda qui va rechercher par le nom et tenant l'id d'un objs dans un tableau d'objet --> retourne un tbleau d'un élément
    search_id = -> (arr, name, tenant_id = nil) { 
      arr.filter_map { |c| c.id if c.name == name && (tenant_id.nil? ? true : c.tenant_id == tenant_id) }
    }

    # RECUPERATION DU FICHIER DANS UN HASH
    # apicSchema = JSON.parse File.read('./ce2_defaultAuto-2022-12-19T06-00-05_1.json')
    apicSchema = JSON.parse File.read('./echange/apic.json')

    # RECHERCHE DES TENANTS
    tenants = apicSchema["polUni"]["children"].filter_map {|child| child["fvTenant"] if child["fvTenant"] }

    #
    # CHARGEMENT DES TENANTS ET RECUPERATIONS DES IDs
    #

    # CREATION DES TENANTS
    new_tenants = tenants.map { |t| { name: t["attributes"]["name"] } }

    # Chargement des tenants et récupération des ids
    Apic::Tenant.insert_all new_tenants unless new_tenants.blank?
    new_tenants =  Apic::Tenant.all # Attention : changement de class -> ActiveRecord Relation maintenant
    
    ### AVEC POSTGRES : new_tenants = Apic::Tenant.insert_all new_tenants, returning: %w[id name] unless new_tenants.blank?
    #
    # PREMIERE ITERATION SUR LE TENANT : CREATION DES FILTRES, CONTRATS, APPLICATION_PROFILES, DOMAINES, L3OUTS ET CONTEXTS
    #

    # Création de tableaux pour récupération des filtres, contrats, application_profiles, L3Outs et contexts crées
    new_filtres, new_contrats, new_application_profiles, new_domaines, new_L3Outs, new_contexts = [ [], [], [], [], [], [] ]

    tenants.each do |tenant|

      # RECUPERATION DU TENANT EN COURS
      current_tenant = new_tenants.find {|t| t.name == tenant["attributes"]["name"]}
      
      # CREATION DES FILTRES DU TENANT
      new_filtres.concat(tenant["children"].filter_map { |c| {name: c["vzFilter"]["attributes"]["name"], tenant_id: current_tenant.id} if c["vzFilter"] })
      
      # CREATION DES CONTRATS DU TENANT
      new_contrats.concat(tenant["children"].filter_map { |c| {name: c["vzBrCP"]["attributes"]["name"], tenant_id: current_tenant.id} if c["vzBrCP"] })

      # CREATION DES APPLICATIONS PROFILES DU TENANT
      new_application_profiles.concat(tenant["children"].filter_map { |c| {name: c["fvAp"]["attributes"]["name"], tenant_id: current_tenant.id} if c["fvAp"] })

      # CREATION DES DOMAINES  DU TENANT
      new_domaines.concat(tenant["children"].filter_map { |c| {name: c["fvBD"]["attributes"]["name"], tenant_id: current_tenant.id} if c["fvBD"] })
      
      # CREATION DES L3Outs DU TENANT
      new_L3Outs.concat(tenant["children"].filter_map { |c| {name: c["l3extOut"]["attributes"]["name"], tenant_id: current_tenant.id} if c["l3extOut"] })

      # CREATION DES CONTEXTS DU TENANT
      new_contexts.concat(tenant["children"].filter_map { |c| {name: c["fvCtx"]["attributes"]["name"], tenant_id: current_tenant.id} if c["fvCtx"] })

    end
    
    #
    # CHARGEMENT EN BASE DES FILTRES, DES CONTRATS, DES APPLICATIONS PROFILES, DES DOMAINES, DES L3OUTS ET DES CONTEXTS
    # ET RECUPERATION DES OBJETS CREES DANS UN ACTIVE RECORD RELATION : ON AURA BESOIN de LEUR ID (permet de ne pas faire de multiple recherche unitaire sur la table contrat)
    #
    Apic::VzFilter.insert_all new_filtres unless new_filtres.blank?
    new_filtres = Apic::VzFilter.all
    
    Apic::Contrat.insert_all new_contrats unless new_contrats.blank?
    new_contrats = Apic::Contrat.all

    Apic::ApplicationProfile.insert_all new_application_profiles unless new_application_profiles.blank?
    new_application_profiles = Apic::ApplicationProfile.all
    
    Apic::Domaine.insert_all new_domaines unless new_domaines.blank?
    new_domaines = Apic::Domaine.all

    Apic::L3Out.insert_all new_L3Outs unless new_L3Outs.blank?
    new_L3Outs = Apic::L3Out.all

    Apic::Context.insert_all new_contexts unless new_contexts.blank?
    new_contexts = Apic::Context.all

    #
    # SECONDE ITERATION SUR LE TENANT : CREATION DES CONTEXTS, L3OUTS ET SUBNETS DES DOMAINES
    #

    # Création de tableaux pour CONTEXTS, L3OUTS ET SUBNETS DES DOMAINES
    new_contexts_domaines, new_l3Outs_domaines, new_subnets = [[], [], []]

    tenants.each do |tenant|

      # ITERATION SUR LES DOMAINES
      tenant["children"].filter_map { |c| c["fvBD"] if c["fvBD"] }.each do |domaine|

        # RECUPERATION DU DOMAINE DU DOMAINE
        current_domaine = new_domaines.find { |d| d.name == domaine["attributes"]["name"] }
        
        new_contexts_domaines.concat(
          domaine["children"]
            .filter_map { |c| new_contexts.find { |con| con.name == c["fvRsCtx"]["attributes"]["tnFvCtxName"] } if c["fvRsCtx"] }
            .filter_map { |con| { apic_domaine_id: current_domaine.id, apic_context_id: con.id } if con } 
          )

        # CREATION DES L3OUTs DU DOMAINE
        new_l3Outs_domaines.concat(
          domaine["children"]
            .filter_map { |c| new_L3Outs.find { |l3| l3.name == c["fvRsBDToOut"]["attributes"]["tnL3extOutName"] } if c["fvRsBDToOut"] }
            .filter_map { |l3| { apic_domaine_id: current_domaine.id, apic_L3Out_id: l3.id } if l3 } 
          )

        # CREATION DES SUBNETs DU DOMAINE
        new_subnets.concat(
          domaine["children"]
            .filter_map { |sub| { name: sub["fvSubnet"]["attributes"]["ip"], domaine_id: current_domaine.id } if sub["fvSubnet"] }
          )

      end
    end

    # CHARGEMENT DES CONTEXTS, L3OUTS ET SUBNETS DES DOMAINES
    Apic::ContextsDomaine.insert_all new_contexts_domaines unless new_contexts_domaines.blank?
    Apic::L3OutDomaine.insert_all new_l3Outs_domaines unless new_l3Outs_domaines.blank?
    Apic::Subnet.insert_all new_subnets unless new_subnets.blank?

    #
    # TROISIEME ITERATION SUR LE TENANT : CREATION DES EPGS, DES DOMAINE_ATTRIBUTES ET DES PATH_ATTRIBUTES
    #

    # Création de tableaux pour les EPGs, les omaines_attributes et les path_attributes
    new_epgs, new_domaine_attributes, new_path_attributes = [ [], [], [] ]

    tenants.each do |tenant|

      # RECUPERATION DU TENANT EN COURS
      current_tenant = new_tenants.find {|t| t.name == tenant["attributes"]["name"]}

      tenant["children"].filter_map { |c| c["fvAp"] if c["fvAp"] }.each do |ap|

        # RECUPERATION DE L'APPLICATION PROFILE EN COURS
        current_application_profile = new_application_profiles.find {|a| a.name == ap["attributes"]["name"]}

        (ap["children"]||[]).filter_map  {|c| c["fvAEPg"] if c["fvAEPg"] }.each do |epg|
          
          # RECUPERATION DU DOMAINE DE L'EPG
          epg_domaine_name = epg["children"].filter_map {|f| f["fvRsBd"]["attributes"]["tnFvBDName"] if f["fvRsBd"]}[0]
          current_domaine = new_domaines.find {|d| d.name == epg_domaine_name && d.tenant_id == current_tenant.id}

          new_epgs << { name: epg["attributes"]["name"], domaine_id: current_domaine.id, application_profile_id: current_application_profile.id }

          # CREATION DES CONTRATS, DES DOMAIN ATTRIBUTS ET DES PATH ATTRIBUTS DE L'EPG
          (epg["children"]||[]).each do |c2|
            new_domaine_attributes << { name: c2["fvRsDomAtt"]["attributes"]["tDn"] } if c2["fvRsDomAtt"]
            new_path_attributes << { name: c2["fvRsPathAtt"]["attributes"]["tDn"] } if c2["fvRsPathAtt"]
          end

        end
      end
    end

    # CHARGEMENT DES EPGs, DES DOMAINES_ATTRIBUTES ET DES PATH_ATTRIBUTES ET RECUPERATION DES OBJETS CREES DANS UN ACTIVE RECORD RELATION

    Apic::Epg.insert_all new_epgs unless new_epgs.blank?
    new_epgs = Apic::Epg.all

    Apic::DomaineAttribut.insert_all new_domaine_attributes.uniq unless new_epgs.blank?
    new_domaine_attributes = Apic::DomaineAttribut.all

    Apic::PathAttribut.insert_all new_path_attributes.uniq unless new_epgs.blank?
    new_path_attributes = Apic::PathAttribut.all
    
    #
    # TROISIEME ITERATION SUR LE TENANT : CREATION DES DOMAINE_ATTRIBUTES ET DES PATH_ATTRIBUTES DES EPGS
    #

    # Création de tableaux domaine_attributs et path_attributs des EPGs
    new_domaine_attributes_epgs, new_epgs_path_attributes = [ [], [], [] ]

    tenants.each do |tenant|

      tenant["children"].filter_map { |c| c["fvAp"] if c["fvAp"] }.each do |ap|

        (ap["children"]||[]).filter_map  {|c| c["fvAEPg"] if c["fvAEPg"] }.each do |epg|
          
          # RECUPERATION DE L'EPG
          current_epg = new_epgs.find { |a| a.name == epg["attributes"]["name"] } 

          # CREATION DES CONTRATS, DES DOMAIN ATTRIBUTS ET DES PATH ATTRIBUTS DE L'EPG
          (epg["children"]||[]).each do |c2|
            new_domaine_attributes_epgs << { apic_epg_id: current_epg.id , apic_domaine_attribut_id: new_domaine_attributes.find { |a| a.name == c2["fvRsDomAtt"]["attributes"]["tDn"] }.id } if c2["fvRsDomAtt"]
            new_epgs_path_attributes << { apic_epg_id: current_epg.id , apic_path_attribut_id: new_path_attributes.find { |a| a.name == c2["fvRsPathAtt"]["attributes"]["tDn"] }.id  } if c2["fvRsPathAtt"]
          end

        end
      end
    end

    # CHARGEMENT  DOMAINES_ATTRIBUTES ET DES PATH_ATTRIBUTES DES EPGs

    Apic::DomaineAttributsEpg.insert_all new_domaine_attributes_epgs.uniq unless new_epgs.blank?

    Apic::EpgsPathAttribut.insert_all new_epgs_path_attributes.uniq unless new_epgs.blank?


    #
    # QUATRIEME ITERATION SUR LE TENANT : CREATION DES USED_CONTRATS
    #

    # Création de tableaux pour les USED_CONTRATS
    new_used_contrats = []

    tenants.each do |tenant|
      # RECUPERATION DU TENANT EN COURS
      current_tenant = new_tenants.find {|t| t.name == tenant["attributes"]["name"]}
      
      # CREATION DES USED_CONTRATS des L3OUTs
      tenant["children"].filter { |f| f["l3extOut"] }.each do |child|
      
        # RECUPERATION DU CURRENT L3OUT
        current_l3Out = new_L3Outs.find {|l| l.name == child["l3extOut"]["attributes"]["name"] && l.tenant_id == current_tenant.id }
        
        # CREATION DES USED CONTRATS DU L3OUT
        new_used_contrats.concat(child["l3extOut"]["children"].filter_map do |c|
          c["l3extInstP"]["children"].filter_map do |c2|
            {
              type: c2["fvRsProv"] ? "Apic::ProvidedContrat" : "Apic::ConsumedContrat",
              contractable_id: current_l3Out.id,
              contractable_type: "Apic::L3Out",
              contrat_id: new_contrats.find { |con| con.name == (c2["fvRsProv"]||c2["fvRsCons"])["attributes"]["tnVzBrCPName"] }.id
            } if c2["fvRsProv"] || c2["fvRsCons"]
          end if c["l3extInstP"] 
        end.flatten)
      end
      
      tenant["children"].filter { |f| f["fvCtx"] }.each do |child|
        # RECUPERATION DU CURRENT CONTEXT
        current_context = new_contexts.find {|l| l.name == child["fvCtx"]["attributes"]["name"] && l.tenant_id == current_tenant.id }
    
        
        # CREATION DES USED CONTRATS DES CONTEXTs
        new_used_contrats.concat(child["fvCtx"]["children"].filter_map do |c|
          (c["vzAny"]["children"] || []).filter_map do |c|
            {
              type: c["vzRsAnyToProv"] ? "Apic::ProvidedContrat" : "Apic::ConsumedContrat",
              contractable_id: current_context.id,
              contractable_type: "Apic::Context",
              contrat_id: new_contrats.find { |con| con.name == (c["vzRsAnyToProv"]||c["vzRsAnyToCons"])["attributes"]["tnVzBrCPName"] }.id
            } if c["vzRsAnyToProv"] || c["vzRsAnyToCons"]
          end if c["vzAny"]
        end.flatten)
      end

      tenant["children"].filter_map { |c| c["fvAp"] if c["fvAp"] }.each do |ap|

        # RECUPERATION DE L'APPLICATION PROFILE
        current_application_profile = new_application_profiles.find { |a| a.name == ap["attributes"]["name"] }        

        (ap["children"]||[]).filter_map  {|c| c["fvAEPg"] if c["fvAEPg"] }.each do |epg|
          
          # RECUPERATION DE L'EPG
          current_epg = new_epgs.find { |a| a.name == epg["attributes"]["name"] && a.application_profile_id ==  current_application_profile.id}        
          
          # CREATION DES USED CONTRATS DES EPGs
          new_used_contrats.concat(epg["children"].filter_map { |c2|
            {
              type: c2["fvRsProv"] ? "Apic::ProvidedContrat" : "Apic::ConsumedContrat",
              contractable_id: current_epg.id,
              contractable_type: "Apic::Epg",
              contrat_id: new_contrats.find { |con| con.name == (c2["fvRsProv"]||c2["fvRsCons"])["attributes"]["tnVzBrCPName"] }.id
            } if c2["fvRsProv"]||c2["fvRsCons"]
          })          

        end
      end
    end

    # CHARGEMENT DES USED_CONTRATS
    Apic::UsedContrat.insert_all new_used_contrats unless new_used_contrats.blank?
        
    
    #
    # CINQUIEME ET DERNIERE ITERATION SUR LE TENANT : CREATION DES FILTRES DES CONTRATS
    #

    # Création de tableaux pour les USED_VZFILTERS
    new_used_filters = []

    tenants.each do |tenant|
      # RECUPERATION DU TENANT EN COURS
      current_tenant = new_tenants.find {|t| t.name == tenant["attributes"]["name"]}

      tenant["children"].filter_map { |c| c["vzBrCP"] if c["vzBrCP"] }.each do |con|
        
        # RECUPERATION DU CURRENT CONTEXT
        current_contrat = new_contrats.find {|l| l.name == con["attributes"]["name"] && l.tenant_id == current_tenant.id }
        
        new_used_filters.concat((con["children"]||[]).filter_map { |v| v["vzSubj"] if v["vzSubj"] }
          .filter_map { |f| f["children"] if f["children"] }.flatten
            .map do |vz|
              if vz["vzInTerm"]||vz["vzOutTerm"]
                ((vz["vzInTerm"]||vz["vzOutTerm"])["children"]||[]).filter_map do |filtre|
                  {
                    type: vz["vzInTerm"] ? "Apic::UsedInFilter" : "Apic::UsedOutFilter",
                    contrat_id: current_contrat.id,
                    vzFilter_id: new_filtres.find {|l| l.name == filtre["vzRsFiltAtt"]["attributes"]["tnVzFilterName"]  }.id
                  } if filtre["vzRsFiltAtt"]
                end 
              elsif vz["vzRsSubjFiltAtt"]
                {
                  type: "Apic::UsedSubFilter",
                  contrat_id: current_contrat.id,
                  vzFilter_id: new_filtres.find {|l| l.name == vz["vzRsSubjFiltAtt"]["attributes"]["tnVzFilterName"]  }.id
                }
              end
            end.flatten.compact)
      end
    end

    # CHARGEMENT DES USED_CONTRATS
    Apic::UsedFilter.insert_all new_used_filters unless new_used_filters.blank?

    #
    # ON FINIT EN CHARGEANT LES TASKS
    #

    # Création de tableaux pour les TASKS
    new_tasks = []

    # SUPPRESSION DU CONTRAT LEGACY
    Apic::Contrat.find_by(name: 'LEGACY').used_contrats.includes(contractable: :application_profile).each do |used_contrat|
      used_contrat_type = used_contrat.type == "Apic::ProvidedContrat" ? "PROVIDED" : "CONSUMED"
      contractable_name = used_contrat.contractable_type == "Apic::Epg" ? "L'EPG #{used_contrat.contractable.application_profile.name} | #{used_contrat.contractable.name}" :  "LE L3OUT #{used_contrat.contractable.name}"
      new_tasks << {name: "SUPPRIMER LE #{used_contrat_type} CONTRAT LEGACY SUR #{contractable_name}" }
    end

    # SUPPRESSION DES FILTRES ANY
    Apic::VzFilter.find_by(name: 'any').contrats.each do |contrat|
      new_tasks << {name: "SUPPRIMER LE FILTRE ANY SUR lE CONTRAT L #{contrat.name}" }
    end

    # SUPPRESSION DES FILTRES HTTP SUR LES CONTRATS CONSUMED_BY L3OUT
    Apic::L3Out.includes(utilised_contrats: :vzFilters).joins(utilised_contrats: :vzFilters).where('apic_vzFilter.name' => 'http').each do |l|
      l.utilised_contrats.each do |contrat|
        new_tasks << {name: "SUPPRIMER LE FILTRE HTTP DU CONTRAT #{contrat.name} CONSOMME PAR LE L3OUT #{l.name}}" }
      end
    end
      

    Apic::Task.insert_all new_tasks unless new_tasks.blank?

  end
end
