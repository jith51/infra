# frozen_string_literal: true

module App
  module Common
    module Queries
      # Tags
      class Tags < ::Queries::BaseQuery
        argument :thing_to_count, String, required: false, default_value: ''

        type [::App::Common::Types::Interfaces::TagInterface], null: false

        def resolve(thing_to_count:)
          thing_to_count.blank? ? Tag.all : Tag.with_counter_for(thing_to_count)
        end
      end
    end
  end
end
