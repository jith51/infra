# frozen_string_literal: true

module Physical
  # Gestion des connections entre chassis
  class Connection < ActiveRecord::Base
    self.primary_key = :local_port_id

    belongs_to :local_port, class_name: 'Physical::Port', inverse_of: :connection
    belongs_to :distant_port, class_name: 'Physical::Port'
    belongs_to :link_type, optional: true
  end
end
