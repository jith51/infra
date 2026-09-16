# frozen_string_literal: true

module Physical
  # Port Slot
  class PortSlot < ActiveRecord::Base
    belongs_to :port_type, required: false
    belongs_to :chassis_class

    validates :name, presence: true, uniqueness: { scope: :chassis_class_id }
  end
end
