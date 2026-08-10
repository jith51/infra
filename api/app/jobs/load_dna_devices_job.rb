require 'uri'
require 'net/http'

class LoadDnaDevicesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Suppresion des enregistrments dans les tables eol, eol_bulletin, equipement, switch et device
    delete_dna_table 

    connect_to_the_api_and_do do |https, headers|
      
      # Récupération des devices
      devices_list = get_devices(https, headers)
      
      # Update des tables détails des devices et récupérations en table(pour avoir les id)
      update_device_detail_tables(devices_list)

      # Formatage des devices et enregistrement en table des devices
      # Et récupération des devices en table (pour avoir leur id)
      all_devices = formate_and_insert_devices(devices_list)
      
      #
      # Traitement switches, équipements, EOLs et des liens devices-eol
      #
      switchs = []
      equipements = []
      eol_bulletins = []
      devices_eol_bulletins = []
      
      all_devices.each do |d|
        # Pour chaque device, on recupére :
        #    - ses bulletins eol que l'on formate (auxquels on ajoute l'id rails du device)
        device_eol_bulletins = get_and_format_eol_bulletins(https, headers, d.uuid)
        eol_bulletins.concat(device_eol_bulletins)
        devices_eol_bulletins << { device_id: d.id, eols: device_eol_bulletins }
        # Et si ce n'est pas une borne :
        if d["family"] != ("Unified AP")
          # - ses switchs (auxquels on ajoute l'id rails du device)
          switchs.concat(get_switchs(https, headers, d.uuid, d.id)) 
          # - ses équipements (auxquels on ajoute l'id rails du device)
          equipements.concat(get_equipements(https, headers, d.uuid, d.id))
        end
      end
      
      # Update des tables détails des switchs et équipements
      update_switch_equipement_detail_tables(switchs, equipements)

      # on enrichit les switchs des infos présentent au niveau des équipements
      switch_serials = []
      switchs.map! do |switch|
        switch_serials << switch["serialNumber"]
        switch_equipement = equipements.find {|e| e["serialNumber"] == switch["serialNumber"] and !e["name"].match(/Stack/)}
        switch.merge(switch_equipement||{})
      end
      # et on les retires les équipements correspondants (! plusieurs equipements possible avec le même numéro de série --> le switch et le stack)
      equipements.delete_if { |e| switch_serials.include?(e["serialNumber"])}
      
      # Formatage des switchs et enregistrement en table des devices
      # Et récupération des devices en table (pour avoir leur id)
      switchs = formate_and_insert_switches(switchs)

      # On affecte les équipements aux switches si nécessaires
      switch_equipements = []
      switchs.each do |s|
        seleted_equipements = equipements.select { |e| e[:device_id] == s.device_id && e["name"]&.start_with?("Switch #{s.stack_member_number}") } || []
        equipements -= seleted_equipements
        switch_equipements.concat(seleted_equipements.map! { |se| se.merge({host_id: s.id, host_type: "Dna::Switch"})})
      end

      # On formate et on enregistre les equipements
      formate_and_insert_equipements(equipements.concat(switch_equipements))
      
      # # Enregistrement des eol_bulletins en table
      Dna::EolBulletin.upsert_all(eol_bulletins.uniq(), unique_by: [:number, :eol_type])

      # # Récupération des eol_bulletins en table (pour avoir keur id)
      all_eol_bulletins = Dna::EolBulletin.all

      # # Formatage des devices_eol_bulletins
      devices_eol_bulletins = formate_devices_eol_bulletins(devices_eol_bulletins, all_eol_bulletins)

      # # Enregistrement en table des devices_eol_bulletins
      Dna::DeviceEolBulletin.upsert_all(devices_eol_bulletins, unique_by: [:device_id, :eol_bulletin_id])

    end
    return 1
  end

  private

    def connect_to_the_api_and_do
      uri = URI.parse('https://10.40.1.104/')

      dna_token = Rails.application.secrets.dna_token

      path = '/dna/system/api/v1/auth/token'
      headers = {
        'Authorization' => "Basic #{dna_token}",
        "content-type" => "application/json"
      }

      Net::HTTP.start(uri.host, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
        # Authentification et recupération du token
        res = https.post(path, '', headers)
        token = JSON.parse(res.body)['Token']
        
        # Construction du headers avec le token
        headers = {
          "x-auth-token" => token,
          "content-type" => "application/json"
        }
        yield https, headers
      end
    end

    def delete_dna_table
      Dna::DeviceEolBulletin.delete_all
      Dna::Switch.delete_all
      Dna::Equipement.delete_all
      Dna::Device.delete_all
      Dna::EolBulletin.delete_all
      Dna::DevicePlatformId.delete_all
    end

    def get_devices(https, headers)
      offset = 1
      devices = []

      loop do
        resultat = https.get("/dna/intent/api/v1/network-device?limit=500&offset=#{offset}", headers)
        j = JSON.parse(resultat.body)['response']
        break if j.blank?
        devices.concat(j)
        offset += 500
      end

      return devices
    end

    def get_switchs(https, headers, api_device_id, device_id)
      resultat = https.get("/dna/intent/api/v1/network-device/#{api_device_id}/stack", headers)
      j = JSON.parse(resultat.body)['response']["stackSwitchInfo"] || []

      return  j.map { |switch| switch.merge( {device_id: device_id}) }
    end

    def get_equipements(https, headers, api_device_id, device_id)
      resultat = https.get("/dna/intent/api/v1/network-device/#{api_device_id}/equipment", headers)
      j = JSON.parse(resultat.body)['response'] || []

      return j.map { |equipement| equipement.merge( {device_id: device_id}) }
    end

    def get_and_format_eol_bulletins(https, headers, api_device_id)
      resultat = https.get("/dna/intent/api/v1/eox-status/device/#{api_device_id}", headers)
      j = JSON.parse(resultat.body)['response']["eoxDetails"] || []
      
      return j.map { |bulletin| formate_eol_bulletin(bulletin) }
    end

    def update_device_detail_tables(devices_list)

      device_families = devices_list.filter_map{|e| {name: e["family"]} if !e["family"].blank? }
      Dna::DeviceFamily.upsert_all(device_families, unique_by: :name)

      device_platform_ids = devices_list.filter_map{|e| 
        {
          name: e["platformId"].gsub(" ","").split(",").uniq().join(",")
        } if !e["platformId"].blank? 
      }
      Dna::DevicePlatformId.upsert_all(device_platform_ids, unique_by: :name)

      device_roles = devices_list.filter_map{|e| {name: e["role"]} if !e["role"].blank? }
      Dna::DeviceRole.upsert_all(device_roles, unique_by: :name)

      device_series = devices_list.filter_map{|e| {name: e["series"]} if !e["series"].blank? }
      Dna::DeviceSeries.upsert_all(device_series, unique_by: :name)

      device_software_types = devices_list.filter_map{|e| {name: e["softwareType"]} if !e["softwareType"].blank? }
      Dna::DeviceSoftwareType.upsert_all(device_software_types, unique_by: :name)

      device_types = devices_list.filter_map{|e| {name: e["type"]} if !e["type"].blank? }
      Dna::DeviceType.upsert_all(device_types, unique_by: :name)

    end
    
    def update_switch_equipement_detail_tables(switchs, equipements)

      switch_platform_ids = switchs.filter_map{|e| {name: e["platformId"]} if !e["platformId"].blank? }
      Dna::SwitchPlatformId.upsert_all(switch_platform_ids, unique_by: :name)

      product_ids = equipements.filter_map{|e| {name: e["productId"]} if !e["productId"].blank? }
      Dna::ProductId.upsert_all(product_ids, unique_by: :name)

      equipement_types = equipements.filter_map{|e| {name: e["vendorEquipmentType"]} if !e["vendorEquipmentType"].blank? }
      Dna::EquipementType.upsert_all(equipement_types, unique_by: :name)

    end

    def formate_and_insert_devices(devices)
      
      device_families = Dna::DeviceFamily.all
      device_platform_ids = Dna::DevicePlatformId.all
      device_roles = Dna::DeviceRole.all
      device_series = Dna::DeviceSeries.all
      device_software_types = Dna::DeviceSoftwareType.all
      device_types = Dna::DeviceType.all

      devices.map! do |device|

        device_family_id = device_families.find {|i| i.name == device["family"]}&.id
        device_platform_id_id =  device["platformId"] ? device_platform_ids.find {|i| i.name == device["platformId"].gsub(" ","").split(",").uniq().join(",")}&.id : nil
        device_role_id = device_roles.find {|i| i.name == device["role"]}&.id
        device_series_id = device_series.find {|i| i.name == device["series"]}&.id
        device_software_type_id = device_software_types.find {|i| i.name == device["softwareType"]}&.id
        device_type_id = device_types.find {|i| i.name == device["type"]}&.id

        {
          uuid: device['instanceUuid'],
          hostname: device['hostname'],
          software_version: device['softwareVersion'],
          device_software_type_id: device_software_type_id,
          device_platform_id_id: device_platform_id_id,
          serial_number: device['serialNumber'],
          device_role_id: device_role_id,
          description: device['description'],
          mac_address: device['macAddress'],
          device_family_id: device_family_id,
          management_ip: device['managementIpAddress'],
          device_series_id: device_series_id,
          device_type_id: device_type_id,
          location: device['location']
        } 
      end
      Dna::Device.insert_all(devices)
      return Dna::Device.all

    end

    def formate_and_insert_switches(switchs)
      equipement_types = Dna::EquipementType.all
      switch_platform_ids = Dna::SwitchPlatformId.all
      
      switchs.map! do |switch|
        {
          description:  switch["description"],
          mac_address: switch["macAddress"],
          serial_number: switch["serialNumber"],
          role: switch["role"],
          stack_member_number: switch["stackMemberNumber"],
          switch_platform_id_id: switch_platform_ids.find {|p| p.name == switch["platformId"]}&.id,
          equipement_type_id: equipement_types.find {|e| e.name == switch["vendorEquipmentType"]}&.id,
          uuid: switch["instanceUuid"],
          software_image: switch["softwareImage"],
          device_id: switch[:device_id]
        }
      end
      Dna::Switch.insert_all(switchs)
      return Dna::Switch.all
    end

    def formate_and_insert_equipements(equipements)
      equipement_types = Dna::EquipementType.all
      product_ids  = Dna::ProductId.all
      
      equipements.map! do |equipement|
        {
          uuid: equipement['instanceUuid'],
          name: equipement["name"],
          description: equipement["description"],
          equipement_type_id: equipement_types.find {|e| e.name == equipement["vendorEquipmentType"]}&.id,
          serial_number: equipement["serialNumber"],
          product_id_id: product_ids.find {|e| e.name == equipement["productId"]}&.id,
          host_id: equipement[:host_id]||equipement[:device_id],
          host_type: equipement[:host_type]||"Dna::Device"
        }
      end
      Dna::Equipement.insert_all(equipements)
    end

    def formate_eol_bulletin(eol)
      return {
        number: eol["bulletinNumber"],
        name: eol["bulletinName"] || eol["bulletinHeadline"],
        eol_type: eol["eoxAlertType"],
        url: eol["bulletinURL"],
        end_of_life_date: formate_date(eol["endOfLifeDate"]),
        last_date_of_support: formate_date(eol["lastDateOfSupport"])
      }
    end

    def formate_devices_eol_bulletins(devices_eol_bulletins, all_eol_bulletins)
      devices_eol_bulletins.map do |d|
        d[:eols].map do |eol|
          { 
            device_id: d[:device_id], 
            eol_bulletin_id: all_eol_bulletins.find {|b| b.number == eol[:number] && b.eol_type == eol[:eol_type]}&.id
          } 
        end
      end.flatten
    end

    def formate_date(date)
      return (date == 0 ? nil : Time.at(date/1000).strftime("%d/%m/%Y"))
    end

end