# frozen_string_literal: true

# Construction des nested attributes
class NestedAttributes
  # Prépare les nested attributes déjà présents dans les paramètres.
  #
  # Exemple :
  #
  # prepare_nested_attributes(
  #   chassis,
  #   args.to_h,
  #   :components_attributes,
  #   :ports_attributes
  # )
  #
  def self.prepare_nested_attributes(record, params, *nested_attributes)
    params = params.deep_dup

    nested_attributes.each do |nested_attribute|
      attributes = params[nested_attribute]

      # L'attribut n'est pas fourni : aucune modification.
      next if attributes.nil?

      association_name = nested_attribute.to_s.delete_suffix('_attributes').to_sym

      params[nested_attribute] =
        build_nested_attributes(record, association_name, attributes)
    end

    params
  end

  private_class_method

  # Ajoute automatiquement `_destroy: true` pour les éléments
  # existants qui ne sont plus présents dans les nested attributes reçus.
  def self.build_nested_attributes(record, association_name, attributes)
    attributes = (attributes || []).map(&:with_indifferent_access)

    association = record.public_send(association_name)

    received_ids = attributes.filter_map { |attr| attr[:id]&.to_i }

    removed =
      association
      .where.not(id: received_ids)
      .map { |item| { id: item.id, _destroy: true } }

    attributes + removed
  end
end
