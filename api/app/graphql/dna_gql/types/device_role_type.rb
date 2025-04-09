module DnaGql
  module Types
    class DeviceRoleType < ::Types::BaseObject
      field :id, ID, null: false
      field :name, String, null: false
      field :number_of_devices, Int, null: true
    end
  end
end