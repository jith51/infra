require 'uri'
require 'net/http'

class LoadDnaDevicesLinkJob < ApplicationJob
  queue_as :default

  def perform(*args)
    
    connect_to_the_api_and_do do |https, headers|
      
      # Récupération des devices
      # 10.40.0.1
      links = []

#       h = {
#           "x-auth-token" => headers["x-auth-token"],
#           "content-type" => "application/json",
#           "entity_type" => "ip_address",
#           "entity_value" => "10.45.1.2",
#         }
# resultat = https.get("/dna/intent/api/v1/device-enrichment-details", h)

      resultat = https.get("/dna/intent/api/v1/topology/physical-topology", headers)
      # # resultat = https.get("/dna/intent/api/v1/network-device/insight/{siteId}/device-link?category=speed", headers)
      res = JSON.parse(resultat.body, object_class: OpenStruct)
      
      # s.each do |site|
      #   resultat = resultat = https.get("/dna/intent/api/v1/network-device/insight/#{site["id"]}/device-link?category=vlan", headers)
      #   j = JSON.parse(resultat.body)['response']
      #   debugger if !j.empty?
      # end
        # j.each do |link|
        #   links.push({
        #     type: link["type"],
        #     endDeviceHostName: link["endDeviceHostName"],
        #     endDeviceIpAddress: link["endDeviceIpAddress"],
        #     endPortDuplex: link["endPortDuplex"],
        #     endPortName: link["endPortName"],
        #     startDeviceHostName: link["startDeviceHostName"],
        #     startDeviceId: link["startDeviceId"],
        #     startDeviceIpAddress: link["startDeviceIpAddress"],
        #     startPortName: link["startPortName"]
        #   })
        # end
        # devices.concat(j)
        # offset += 500
      # end
      # s.each
      # return  j.map { |switch| switch.merge( {device_id: device_id}) }
      # puts links
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
end