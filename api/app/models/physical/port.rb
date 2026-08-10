# frozen_string_literal: true

module Physical
  # Port
  class Port < ActiveRecord::Base
    belongs_to :port_type, required: false
    belongs_to :host, polymorphic: true

    # has_one :connection, foreign_key: :local_id, dependent: :destroy
    # accepts_nested_attributes_for :connection, allow_destroy: true

    validates :name, presence: true, uniqueness: { scope: %i[host_id host_type] }
  end
end
