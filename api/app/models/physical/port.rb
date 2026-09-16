# frozen_string_literal: true

module Physical
  # Port
  class Port < ActiveRecord::Base
    belongs_to :port_type, optional: true
    belongs_to :chassis

    has_one :connection, foreign_key: :local_port_id, inverse_of: :local_port, dependent: :destroy
    accepts_nested_attributes_for :connection, allow_destroy: true

    has_one :connected_port, through: :connection, source: :distant_port

    has_one :connected_chassis, through: :connected_port, source: :chassis

    validates :name, presence: true, uniqueness: { scope: :chassis_id }
  end
end
