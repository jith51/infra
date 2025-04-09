module ApicGql
  module Types
    module Interface
      module BaseContractable
        include ::Types::BaseInterface
      
        field :name, String, null: false
        
        field :provided_contrats, [::ApicGql::Types::ProvidedContratType]
        field :consumed_contrats, [::ApicGql::Types::ConsumedContratType]

        field :used_contrats, [::ApicGql::Types::UsedContratType]
        
        definition_methods do
          def resolve_type(object, context)
            "::ApicGql::Types::#{object.class.name.demodulize}Type".constantize
          end
        end
        # orphan_types Types::Apic::ContractableEpgType, Types::Apic::ContractableContextType, Types::Apic::ContractableL3OutType
        # orphan_types Types::Apic::ContractableContextType, Types::Apic::ContractableL3OutType
      end
    end
  end
end