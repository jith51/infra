# frozen_string_literal: true

# Tag
class Tag < ActiveRecord::Base
  has_many :tags_attachments

  def self.with_counter_for(thing_to_count)
    Tag
      .left_outer_joins(:tags_attachments)
      .select(:id, :name, 'COUNT(tags_attachments.taggable_type) AS number_of_things')
      .where(tags_attachments: { taggable_type: to_type(thing_to_count) })
      .group(:id, :name)
  end

  def self.to_type(thing_to_count)
    case thing_to_count
    when 'chassis'
      'Physical::Chassis'
    else
      'Inconnu'
    end
  end
end
