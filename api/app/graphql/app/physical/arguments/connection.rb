# frozen_string_literal: true

module App
  module Physical
    module Types
      module Arguments
        # ConnectionArguments
        class Connection < ::Types::BaseInputObject
          graphql_name 'ConnectionInput'

          argument :id, ID, required: false
          argument :distant_id, ID,  required: true
          argument :link_type_id, ID,  required: false
          argument :_destroy, Boolean, required: false

          # def prepare
          #   {
          #     id: id,
          #     distant_id: distant_id,
          #     link_type_id: link_type_id,
          #     _destroy: _destroy
          #   }
          # end
        end
      end
    end
  end
end
