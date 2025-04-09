# apps/graphql/custom_types/file_type
class Types::FileType < Types::BaseScalar
  description "A valid URL, transported as a string"

  def self.coerce_input(file, context)
    return nil if file.blank?
    definitive_file = file.class == Array ? file[0]["file"] :file["file"]
    
    if definitive_file.class == ApolloUploadServer::Wrappers::UploadedFile
      { io: definitive_file.to_io, filename: definitive_file.original_filename, content_type: definitive_file.content_type } 
    else
       file[0]
    end
    # debugger
    # debugger
    # ActionDispatch::Http::UploadedFile.new(
    #   filename: file["file"].original_filename,
    #   type: file["file"].content_type,
    #   headers: file["file"].headers,
    #   tempfile: file["file"].tempfile
    # )
  end
end