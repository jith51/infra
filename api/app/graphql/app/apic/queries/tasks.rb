# frozen_string_literal: true

module App
  module Apic
    module Queries
      # Taches
      class Tasks < ::Queries::BaseQuery
        type [::App::Apic::Types::ATaskType], null: false

        def resolve
          ::Apic::Task.all
        end
      end
    end
  end
end
