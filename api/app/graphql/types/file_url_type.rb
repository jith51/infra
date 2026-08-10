# frozen_string_literal: true

module Types
  # Url pour un fichier
  class FileUrlType < ::Types::BaseObject
    # field :file_url, String, null: false
    field :filename, String, null: false
    field :type, String, null: false
    field :content_base64, String, null: false
  end
end
