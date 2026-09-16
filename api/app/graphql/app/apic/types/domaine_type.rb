# frozen_string_literal: true

module App
  module Apic
    module Types
      # DomaineType
      class DomaineType < ::Types::BaseObject
        field :name, String, null: false
        field :contexts, [::App::Apic::Types::ContextType]
        field :L3Outs, [::App::Apic::Types::L3OutType]
      end
    end
  end
end
