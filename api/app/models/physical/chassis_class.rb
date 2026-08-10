# frozen_string_literal: true

module Physical
  # Chassis Class
  class ChassisClass < ActiveRecord::Base
    before_validation :set_default_custom_attributes, on: %i[create update]

    belongs_to :chassis_powertype, required: false

    has_one_attached :front_image, dependent: :purge
    has_one_attached :back_image, dependent: :purge

    has_many :chassis, dependent: :restrict_with_error

    has_many :components, as: :host, dependent: :destroy
    accepts_nested_attributes_for :components, allow_destroy: true

    has_many :ports, as: :host, dependent: :destroy
    accepts_nested_attributes_for :ports, allow_destroy: true

    validates :name, presence: true, uniqueness: true

    # Validation du champ custom_attributes
    validates_with ::CustomAttributesValidator, association_name: :chassis_powertype

    def front_image_url_path
      get_url_path_for(front_image)
    end

    def back_image_url_path
      get_url_path_for(back_image)
    end

    private

    def get_url_path_for(image)
      image.blob.nil? ? nil : Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
    end

    def set_default_custom_attributes
      # ON récupére toutes les custom attributs que l'on met à nil
      custom_attributes_definition =
        if chassis_powertype.blank?
          {}
        else
          chassis_powertype.self_and_ancestors.map(&:custom_attributes).reduce({}, :merge)
        end.transform_values { |_| nil }
      self.custom_attributes = custom_attributes_definition.merge(custom_attributes.slice(*custom_attributes_definition.keys))
    end
  end
end
