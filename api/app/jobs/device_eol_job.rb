require 'uri'
require 'net/http'

class DeviceEolJob < ApplicationJob
  queue_as :default

  def perform(*args)
    return liste_des_sevreurs('CI0161')
  end

  def liste_des_sevreurs(nom_du_ci)
    # On récupére la liste des serveurs depuis device42
    data = get_data_from_device42(nom_du_ci)

    # On trouve tous les établissements concernés et on itère dessus
    liste_des_differentes_valeurs(data, 'device_etablissement').map do |e| # retourne un tableau
      # Pour chaque établissement du tableau

      # On recherche les serveurs de cet établissement
      d = data.select {|d| d['device_etablissement'].include? e}

      # Puis on trouve tous les services levels de cet établissement et on itère dessus
      # pour retourner son nom et la liste des serveurs concernés
      service_levels = liste_des_differentes_valeurs(d, 'device_service_level').map do |l| # retourne un tableau
        { 
          nom: l, serveurs: d.filter_map {|s| formate_serveur(s) if s['device_service_level'].include? l}
        }
      end

      # Finalement on retourne le nom de l'établissement et la liste des service levels
      { 
        etablissement: e,
        service_levels: service_levels
      }

    end
  end

  def get_data_from_device42(nom_du_ci)
    uri = URI.parse('https://device42.domchurs.ad')

    basic_auth = 'Basic ' + Base64.encode64('2259d574db744f6d904c0cd9de3bc634:a3ee1479eb3b4214bd175e80bd20fdd7_b576b061317e4745af9281f528d96c64').gsub(/\n/, '')
    path = '/tauth/1.0/token/'
    headers = {'Authorization' => basic_auth}
    
    resultat = nil

    Net::HTTP.start(uri.host, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
      # Authentification et recupération du token
      res = https.post(path, '', headers)
      t = JSON.parse(res.body)

      # Construction du headers avec le token
      headers = {'Authorization' => 'Bearer ' + t['token']}
          
      # # On récupére la requête
      res = https.get('/api/1.0/saved_doql_queries/?name=TEST_JT', headers)
      base_query = JSON.parse(res.body)['queries'][0]["saved_query"]

      # On construit la requête pour le CI
      path = path_for_ci(base_query, nom_du_ci)
      
      # On lance la requete
      resultat = https.get(path, headers)
      
    end

    return JSON.parse(resultat.body)
  end

  def path_for_ci(base_query, ci_name)
    query = ERB::Util.url_encode(base_query + " WHERE app.name  = '#{ci_name}'").gsub(/\n/, '').gsub(/\r/, '')
    return "/services/data/v1.0/query/?query=#{query}&output_type=json"
  end

  def liste_des_differentes_valeurs(liste, attribut)
    liste.map {|d| d[attribut].split(',')}.flatten.uniq
  end

  def formate_serveur(serveur)
    return {
      nom: serveur['device_name'],
      role: serveur['device_role'],
      cpu: serveur['device_cpu'],
      ram: serveur['device_ram'],
      os: serveur['os_name'],
      os_fin_de_vie: serveur['os_end_of_life'],
      os_fin_de_support: serveur['os_end_of_support'],
      os_fin_de_support_etendu: serveur['os_extended_end_of_support_date']
    } 
  end
end

