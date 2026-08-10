# frozen_string_literal: true

module Concern
  # Construction des nested attributes
  module NestedAttributes
    extend ActiveSupport::Concern

    private

    # Construction des nested attributes pour une association.
    # Ajoute automatiquement _destroy: true pour les éléments existants
    # qui ne sont plus présents dans les paramètres reçus.
    def build_nested_attributes(record, association_name, attributes)
      return [] if attributes.blank?

      received_ids = attributes.filter_map { |attr| attr[:id]&.to_i }

      removed = record.public_send(association_name)
                      .where.not(id: received_ids)
                      .map { |item| { id: item.id, _destroy: true } }

      attributes + removed
    end

    # Préparation des nested attributes pour plusieurs associations.
    #
    # Exemple :
    #
    # params = prepare_nested_attributes(
    #   chassis,
    #   args.to_h,
    #   :components,
    #   :ports
    # )
    #
    # Transforme :
    # {
    #   nesteds: [...]
    # }
    #
    # en :
    # {
    #   nesteds_attributes: [...]
    # }
    #
    def prepare_nested_attributes(record, params, *associations)
      params = params.deep_dup

      associations.each do |association|
        attributes = params.delete(association)

        next if attributes.blank?

        params[:"#{association}_attributes"] =
          build_nested_attributes(record, association, attributes)
      end

      params
    end
  end
end
