# frozen_string_literal: true

module Physical
  # Chassis
  class Chassis < ActiveRecord::Base
    before_validation :set_default_custom_attributes, on: %i[create update]

    include Taggable

    belongs_to :chassis_class

    has_many :ports, dependent: :destroy
    accepts_nested_attributes_for :ports, allow_destroy: true

    has_many :components, dependent: :destroy
    accepts_nested_attributes_for :components, allow_destroy: true

    validates :name, presence: true, uniqueness: true
    # Validation du champ custom_attributes
    validates_with ::CustomAttributesValidator, association_name: :chassis_class

    def set_default_custom_attributes
      # On récupére toutes les custom attributs que l'on met à nil
      definitions = (chassis_class&.custom_attributes_definition || {}).transform_values { |_| nil }
      self.custom_attributes = definitions.merge(custom_attributes.slice(*definitions.keys))
    end
  end
end
