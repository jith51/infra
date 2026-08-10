# frozen_string_literal: true

module Physical
  # Chassis
  class Chassis < ActiveRecord::Base
    include Taggable

    belongs_to :chassis_class

    has_many :ports, as: :host, dependent: :destroy
    accepts_nested_attributes_for :ports, allow_destroy: true

    has_many :components, as: :host, dependent: :destroy
    accepts_nested_attributes_for :components, allow_destroy: true

    validates :name, presence: true, uniqueness: true
  end
end
