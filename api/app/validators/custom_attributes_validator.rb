# frozen_string_literal: true

# Validation d'un custom_attibutes définit dans une classe associé à l'objet
# Class 1 posséde un attribut custom_attributes (définition de ces customs_attributes) structurés ainsi
#   {
#     name1: {label: 'label1', type: 'number|boolean|text'},
#     name2: {label: 'label2', type: 'number|boolean|text'}
#   }
# Class 2 belongs_to Class 1 posséde un attribut custom_attributes qui doit être sous la forme
#   {
#     name1: valeur_de_type_identique_a_class1.name1.type,
#     name2: valeur_de_type_identique_a_class1.name2.type,
#   }
#
class CustomAttributesValidator < ActiveModel::Validator
  def validate(record)
    # On va rechercher l'association
    association = record.public_send(options[:association_name])

    # Si pas d'association alors ok
    return if association.blank?

    definitions = association.self_and_ancestors.map(&:custom_attributes).reduce({}, :merge) || {}
    values = record.custom_attributes || {}

    # Si pas de définitions et pas de valeurs alors ok
    return if definitions.blank? && values.blank?

    # On vérifie qu'il n'y a pas de keys non définit
    validate_unknown_keys(record, definitions, values)

    # On vérifie que toutes les keys définies dans association sont présentes
    validate_presence_keys(record, definitions, values)

    # On vérifie le type de chaque valeurs
    definitions.each do |key, config|
      validate_type(record, key, values[key], config['type']) unless values[key].blank?
    end
  end

  private

  def validate_unknown_keys(record, definitions, values)
    unknown_keys = values.keys - definitions.keys

    unknown_keys.each do |key|
      record.errors.add(:custom_attributes, "#{key} n'existe pas")
    end
  end

  def validate_presence_keys(record, definitions, values)
    miss_keys = definitions.keys - values.keys

    miss_keys.each do |key|
      record.errors.add(:custom_attributes, "#{key} n'est pas défini")
    end
  end

  def validate_type(record, key, value, type)
    valid = case type
            when 'boolean'
              [true, false].include?(value)
            when 'number'
              value.is_a?(Numeric)
            else
              value.is_a?(String)
            end

    record.errors.add(:custom_attributes, "#{key} doit être de type #{type}") unless valid
  end
end
