# frozen_string_literal: true

module App
  module Apic
    module Types
      # ServeurType
      class ServeurType < ::Types::BaseObject
        field :name, String, null: false
        field :powerstate, Integer, null: false
        field :os, String
      end
    end
  end
end
