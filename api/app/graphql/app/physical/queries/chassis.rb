# frozen_string_literal: true

module App
  module Physical
    module Queries
      # Chassis
      class Chassis < ::Queries::BaseQuery
        type [::App::Physical::Types::Chassis], null: false

        argument :name, String, required: false
        argument :tag_ids, [String], required: false, default_value: []
        argument :chassis_class_ids, [String], required: false, default_value: []
        argument :limit, Integer, required: false
        argument :page, Integer, required: false

        def resolve(limit:, page:, name:, tag_ids:, chassis_class_ids:)
          # scope = ::Physical::Chassis.includes(:tags, chassis_class: %i[front_image back_image]).all
          scope = ::Physical::Chassis.left_outer_joins(:chassis_class).includes(:tags, chassis_class: [:chassis_powertype])
          scope = scope.where('physical_chassis.name LIKE ?', "%#{::Physical::Chassis.sanitize_sql_like(name)}%") if name.present?
          scope = scope.where(chassis_class: { id: chassis_class_ids }) if chassis_class_ids.present?
          scope = scope.where(tag_clause(tag_ids)) if tag_ids.present?
          scope.limit(limit || 10).offset(page || 0)
        end

        private

        def tag_clause(tag_ids)
          " EXISTS (SELECT 1
            FROM tags_attachments
              WHERE tags_attachments.taggable_id = physical_chassis.id
                AND tags_attachments.taggable_type = 'Physical::Chassis'
                AND tags_attachments.tag_id = ANY('{#{tag_ids.map(&:to_s).join(',')}}'::int[])
                )"
        end
      end
    end
  end
end
