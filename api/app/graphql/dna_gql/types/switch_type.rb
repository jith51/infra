module DnaGql
  module Types
    class SwitchType < ::Types::BaseObject
      field :uuid, String, null: true
      field :description, String, null: true
      field :mac_address, String, null: true
      field :serial_number, String, null: true
      field :role, String, null: true
      field :stack_member_number, String, null: true
      field :software_image, String, null: true
      field :switch_platform_id, ::DnaGql::Types::SwitchPlatformIdType
      field :equipement_type, ::DnaGql::Types::EquipementTypeType
      field :equipements, [::DnaGql::Types::EquipementType]
    end
  end
end