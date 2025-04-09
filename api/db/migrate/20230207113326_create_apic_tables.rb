class CreateApicTables < ActiveRecord::Migration[7.0]
  def change
    create_table :apic_tenants do |t|
      t.string :name, null: false, index: true
    end

    create_table :apic_application_profiles do |t|
      t.string :name, null: false, index: true
      t.belongs_to :tenant, null: false, index: true
    end

    create_table :apic_epgs do |t|
      t.string :name, null: false, index: true
      t.belongs_to :application_profile, null: false, index: true
      t.belongs_to :domaine, null: false, index: true
    end

    create_table :apic_domaines do |t|
      t.string :name, null: false, index: true
      t.belongs_to :tenant, null: false, index: true
    end
    
    create_table :apic_subnets do |t|
      t.string :name, null: false, index: true
      t.belongs_to :domaine, null: false, index: true
    end
    
    create_join_table :apic_domaines, :apic_contexts
    create_join_table :apic_domaines, :apic_L3Out

    
    create_table :apic_domaine_attributs do |t|
      t.string :name, null: false, index: true
    end

    create_join_table :apic_epgs, :apic_domaine_attributs

    create_table :apic_path_attributs do |t|
      t.string :name, null: false, index: true
    end

    create_join_table :apic_epgs, :apic_path_attributs


    create_table :apic_contexts do |t|
      t.string :name, null: false, index: true
      t.belongs_to :tenant, null: false, index: true
    end

    create_table :apic_L3Out do |t|
      t.string :name, null: false, index: true
      t.belongs_to :tenant, null: false, index: true
    end


    create_table :apic_contrats do |t|
      t.string :name, null: false, index: true      
      t.belongs_to :tenant, null: false, index: true
    end

    create_table :apic_used_contrats do |t|
      t.string :type, null: true, index: true
      t.belongs_to :contrat, null: false, index: true
      t.belongs_to :contractable, polymorphic: true, index: true
    end

    create_table :apic_vzFilter do |t|
      t.string :name, null: false, index: true
      t.belongs_to :tenant, null: false, index: true
    end

    create_table :apic_used_filters do |t|
      t.string :type, null: true, index: true
      t.belongs_to :vzFilter, null: false, index: true
      t.belongs_to :contrat,  null: false, index: true
    end

    create_table :apic_tasks do |t|
      t.string :name, null: false
    end

  end
end
