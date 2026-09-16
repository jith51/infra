# frozen_string_literal: true

module App
  module Apic
    module Types
      module Interface
        # BaseContractable
        module BaseContractable
          include ::Types::BaseInterface

          field :name, String, null: false

          field :provided_contrats, [::App::Apic::Types::ProvidedContratType]
          field :consumed_contrats, [::App::Apic::Types::ConsumedContratType]

          field :used_contrats, [::App::Apic::Types::UsedContratType]

          definition_methods do
            def resolve_type(object, _)
              "::App::Apic::Types::#{object.class.name.demodulize}Type".constantize
            end
          end
          # orphan_types Types::Apic::ContractableEpgType, Types::Apic::ContractableContextType, Types::Apic::ContractableL3OutType
          # orphan_types Types::Apic::ContractableContextType, Types::Apic::ContractableL3OutType
        end
      end
    end
  end
end
