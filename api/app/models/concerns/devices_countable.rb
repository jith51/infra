# frozen_string_literal: true

# Concern pour les dna pouvant être compté
module DevicesCountable
  extend ActiveSupport::Concern

  included do
    has_many :devices

    def self.with_number_of_devices
      joins(:devices)
        .group(:id, :name)
        .count('dna_devices.id')
        .map { |k, v| { id: k[0], name: k[1], number_of_devices: v } }
    end
  end
end
