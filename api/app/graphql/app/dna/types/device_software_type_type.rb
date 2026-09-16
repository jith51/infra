# frozen_string_literal: true

module App
  module Dna
    module Types
      class DeviceSoftwareTypeType < ::Types::BaseObject
        field :id, ID, null: false
        field :name, String, null: false
        field :number_of_devices, Int, null: true
      end
    end
  end
end
