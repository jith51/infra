# frozen_string_literal: true

module Concern
  # Construction des nested attributes
  module NestedAttributes
    extend ActiveSupport::Concern

    private

    def prepare_nested_attributes(record, params, *nested_attributes)
      ::NestedAttributes.prepare_nested_attributes(record, params, *nested_attributes)
    end
  end
end
