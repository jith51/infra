# frozen_string_literal: true

module App
  module Dna
    module Types
      class EquipementType < ::Types::BaseObject
        field :name, String, null: true
        field :description, String, null: true
        field :serial_number, String, null: true
        field :uuid, String, null: true
        field :product_id, ::App::Dna::Types::ProductIdType
        field :equipement_type, ::App::Dna::Types::EquipementType
        # field :product_id, ::ApicDna::Types::ProductIdType
      end
    end
  end
end
