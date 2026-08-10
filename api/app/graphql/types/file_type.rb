# apps/graphql/custom_types/file_type
class Types::FileType < Types::BaseScalar
  description "A valid URL, transported as a string"

  def self.coerce_input(file, _ctx)
    # Si blank on retourne nil pour suppression
    return nil if file.blank?
    # Si ce n'est pas un fichier il s'agit d'un path et on le renvoir comme tel
    return file if !(file.try :original_filename)
    # sinon enregistrement du fichier
    ActionDispatch::Http::UploadedFile.new(
      filename: file.original_filename,
      type: file.content_type,
      headers: file.headers,
      tempfile: file.tempfile
    )
  end
end