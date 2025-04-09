require 'uri'
require 'net/http'

module Device42

    attr_reader :token, :config

    def initialize
        @config = Rails.application.config_for(:device42)
        @token = get_api_token(@config)
    end

    def create_device_ci(nom_ci)
        post_api_ci(nom_ci)
    end

    def delete_device_ci(nom_ci)
        delete_api_ci(nom_ci)
    end

    def liste_des_seveurs(nom_du_ci)
        # on formate le résultat sous la forme
        # [ { etablissement: "nom_etablissement",
        #     service_levels: [ { 
        #         nom: "service_level_name",
        #         serveurs: [ {
        #             nom: "nom_du_serveur",
        #             role: "role_du_serveur"
        #             cpu: "cpu",
        #             ram: "ram",
        #             os: "nom_os",
        #             os_fin_de_vie: "os_fin_de_vie",
        #             os_fin_de_support: "os_fin_de_support",
        #             os_fin_de_support_etendu: "os_fin_de_support_etenbdu"
        #           }, ...
        #         ]
        #       }, ...
        #     ]
        #   }, ... 
        # ]
        
        # On récupére la liste des serveurs depuis device42
        data = get_api_ci_serveurs(nom_du_ci)

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
    
    private
        attr_accessor :token, :config

        def get_api_token(config)

            cache = ActiveSupport::Cache::MemoryStore.new
            device42_token = cache.read('device42_token')
            
            if  device42_token.nil? || device42_token['expires'].to_date < ::DateTime.now()
                uri = URI.parse(config.url)

                path = '/tauth/1.0/token/'
                headers = {'Authorization' => 'Basic ' + Base64.encode64("#{config.user}:#{config.password}").gsub(/\n/, '')}

                token = nil

                Net::HTTP.start(uri.host, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
                    # Authentification et recupération du token
                    res = https.post(path, '', headers)
                    device42_token = JSON.parse(res.body)
                    cache.write('device42_token', device42_token)
                end
            end

            return device42_token['token']
        end
        
        def post_api_ci(nom_ci)
            uri = URI.parse(@config.url)
            path = '/api/1.0/businessapps/'
            headers = { 'Authorization' => 'Bearer ' + @token }
            data = "name=#{nom_ci}"

            Net::HTTP.start(uri.host, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
                res = https.post(path, data, headers)
            end
        end

        def delete_api_ci(nom_ci)
            uri = URI.parse(@config.url)
            path = "/api/1.0/businessapps/?name=#{nom_ci}"
            headers = { 'Authorization' => 'Bearer ' + @token }

            Net::HTTP.start(uri.host, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
                res = https.get(path, headers)
                ci_id = JSON.parse(res.body)['businessapps'][0]['businessapp_id']
                res = https.delete("/api/1.0/businessapps/#{ci_id}")
            end
        end

        def get_api_ci_serveurs(nom_du_ci)

            uri = URI.parse(@config.url)

            resultat = nil
            
            Net::HTTP.start(uri.host, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|

                headers = { 'Authorization' => 'Bearer ' + @token }
            
                # # On récupére la requête
                res = https.get("/api/1.0/saved_doql_queries/#{@config.ci_serveurs_query_id}/", headers)
                # res = https.get("/api/1.0/saved_doql_queries/?name=#{@config.ci_serveurs_query_name}", headers)
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