# frozen_string_literal: true

module Physical
  # Classe de base des powertypes
  class ChassisPowertype < ::Powertype
    validates :name, presence: true, uniqueness: true
    has_many :chassis_classes, dependent: :restrict_with_error
  end
end
