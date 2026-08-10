require "csv"

class DnaMaintenanceFile < ApplicationJob
  queue_as :default

  def perform(*args)
    family_id = Dna::DeviceFamily.find_by(name: 'Switches and Hubs').try :id
    devices = Dna::Device.where(device_family_id: family_id)

    equipement_type_ids = [
      Dna::EquipementType.where('dna_equipement_types.name ~* ?', 'Chassis').map(&:id),
      Dna::EquipementType.where('dna_equipement_types.name ~* ?', 'PowerSupply').map(&:id),
      Dna::EquipementType.where('dna_equipement_types.name ~* ?', 'Stack').map(&:id)
    ].flatten

    output = [['hostname', 'description', 'serial_number','equipement_type','prodct_id/platform_id']]

    get_equipements = -> (object, hostname = nil) {
      object.equipements.where("equipement_type_id = ANY('{#{equipement_type_ids.join(',')}}'::int[])").each do |e|
        output << [hostname, e.description, e.serial_number, e.equipement_type.try(:name), e.product_id.try(:name)]
      end
    }

    devices.each do |d|
      get_equipements.call(d, d.hostname)
      d.switches.each do |s|
        output <<  [d.hostname, s.description, s.serial_number, s.equipement_type.try(:name), s.switch_platform_id.try(:name)]
        get_equipements.call(s, d.hostname)
      end
    end

    
    File.write('maintenance.csv', output.map(&:to_csv).join)

    return 0
  end
end

