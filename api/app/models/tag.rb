# frozen_string_literal: true

# Tag
class Tag < ActiveRecord::Base
  has_many :tags_attachments, dependent: :destroy, foreign_key: :tag_id
  # has_many :taggables, through: :tags_attachments, source: :taggable

  def self.with_counter_for(thing_to_count)
    Tag
      .left_outer_joins(:tags_attachments)
      .select(:id, :name, 'COUNT(tags_attachments.taggable_type) AS number_of_things')
      .where(tags_attachments: { taggable_type: to_type(thing_to_count) })
      .group(:id, :name)
  end

  TAGGABLE_TYPES = {
    'chassis' => 'Physical::Chassis'
  }.freeze

  def self.to_type(type)
    TAGGABLE_TYPES.fetch(type)
  end
  # def self.to_type(thing_to_count)
  #   case thing_to_count
  #   when 'chassis'
  #     'Physical::Chassis'
  #   else
  #     'Inconnu'
  #   end
  # end
end
