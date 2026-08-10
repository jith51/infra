class DnaToPhysicalJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Physical::ChassisClass.upsert_all(
      Dna::Equipement
        .select("
          dna_product_ids.name name,
          dna_product_ids.name part_number,
          dna_device_types.name model,
          dna_equipement_types.name vendor_equipment_type
        ")
        .joins(:equipement_type, :product_id)
        .joins("left outer join dna_devices on dna_devices.id = dna_equipements.host_id and dna_equipements.host_type='Dna::Device'")
        .joins("left outer join dna_device_types on dna_devices.device_type_id = dna_device_types.id")
        .where("dna_equipement_types.name ~* ?", "Chassis").to_a
      .concat(Dna::Switch
          .select("
            dna_device_platform_ids.name name,
            dna_device_platform_ids.name part_number,
            dna_device_types.name model,
            dna_equipement_types.name vendor_equipment_type
          ")
          .joins(:equipement_type, device: [:device_type, :device_platform_id])
          .where("dna_equipement_types.name ~* ?", "Chassis").to_a
      )
        .map {|e| {
          name: e.name.split(",").first.delete(","),
          fournisseur: "Cisco",
          model: e.model,
          height: 1,
          part_number: e.part_number.split(",").first.delete(","),
          vendor_equipment_type: e.vendor_equipment_type
          }
        }.uniq{|e| e[:name]},
      unique_by: :name)

    return 0
  end
end

