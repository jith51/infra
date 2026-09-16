# frozen_string_literal: true

# class de liaison entre les tags et les choses taggués
class TagsAttachment < ActiveRecord::Base
  self.primary_key = [:tag_id, :taggable_type, :taggable_id]

  belongs_to :tag
  belongs_to :taggable, polymorphic: true
  validates_presence_of :tag, :taggable
  validates_uniqueness_of :tag_id, scope: %i[taggable_type taggable_id]
end
