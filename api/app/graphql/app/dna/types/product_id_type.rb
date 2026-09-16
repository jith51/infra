# frozen_string_literal: true

module App
  module Dna
    module Types
      class ProductIdType < ::Types::BaseObject
        field :id, ID, null: false
        field :name, String, null: false
      end
    end
  end
end
