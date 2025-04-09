class LoadApicServeurJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Apic::Serveur.delete_all

    # RECUPERATION DU FICHIER DANS UN HASH
    apicVMWARE= JSON.parse File.read('./echange/vmreseaux.json')

    aps = Apic::ApplicationProfile.all
    epgs = Apic::Epg.all

    new_serveurs = []
    erreurs = []
    # RECHERCHE D
    apicVMWARE.each do |k, v| puts 
      str = k.split('|')
      if str&[1] && str&[2]
        application_profile_id = aps.records.filter_map { |c| c.id if c.name == str[1] }
        epg_id = epgs.records.filter_map { |c| c.id if c.name == str[2] && c.application_profile_id == application_profile_id[0] }
        if !epg_id.blank?
          v.each { |s| new_serveurs << { name: s["Name"], powerstate: s["PowerState"], epg_id: epg_id[0], os: s["OS"] } }
        else
          erreurs << k
        end
      end
    end
    
    Apic::Serveur.insert_all new_serveurs

    # puts new_serveurs
    puts erreurs
  end
end

