# frozen_string_literal: true

# Concern pour les objects pouvants être taggué
module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :tags_attachments, as: :taggable, dependent: :destroy
    has_many :tags, through: :tags_attachments
  end
end
