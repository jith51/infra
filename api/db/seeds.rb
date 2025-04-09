# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create! email: 'jteo51@gmail.com', password:'titi@51', password_confirmation:'titi@51'

Time::List.create! name: 'default'

10.times do |index|
    Time::Task.create!(name: Faker::Name.name)
end

Network::Site.create! name: "GHT"
Network::Site.create! name: "Hopital Sebastopol"
Network::Site.create! name: "Maison Blanche"
Network::Site.create! name: "NH-FABRIC"
Network::Site.create! name: "Wilson"

p = Physical::Powertype.create name:'Package', instance_class_name: 'Physical::PackageClass', primary: true
f = Physical::Powertype.create name:'Frame', instance_class_name: 'Physical::FrameClass', parent_id: p.id, primary: true
Physical::Powertype.create name:'Rack', instance_class_name: 'Physical::RackClass', parent_id: f.id, primary: true
Physical::Powertype.create name:'Chassis', instance_class_name: 'Physical::ChassisClass', parent_id: f.id, primary: true
Physical::Powertype.create name:'Card', instance_class_name: 'Physical::CardClass', parent_id: p.id, primary: true
c = Physical::Powertype.create name:'Component', instance_class_name: 'Physical::ComponentClass', primary: true
co = Physical::Powertype.create name:'Connector', instance_class_name: 'Physical::ConnectorClass', parent_id: c.id, primary: true
Physical::Powertype.create name:'Slot', instance_class_name: 'Physical::SlotClass', parent_id: co.id, primary: true
