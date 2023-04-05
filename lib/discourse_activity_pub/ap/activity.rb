# frozen_string_literal: true

module DiscourseActivityPub
  module AP
    class Activity < Object
      def base_type
        'Activity'
      end

      def actor
        return nil unless stored
        AP::Actor.new(stored: stored.actor)
      end

      def object
        return nil unless stored
        AP::Object.get_klass(stored.object.ap_type).new(stored: stored.object)
      end

      def process
        return false unless process_json

        raise NotImplementedError
      end

      def response?
        type && Response.types.include?(type)
      end

      def composition?
        type && Compose.types.include?(type)
      end

      def self.types
        activity = self.new
        raise NotImplementedError unless activity.respond_to?(:types)
        activity.types
      end

      protected

      def process_json
        actor = AP::Actor.resolve_and_store(json[:actor])
        return process_failed("cant_create_actor") unless actor.present?

        model = Model.find_by_ap_id(json['object'])
        return process_failed("object_not_valid") unless model.present?

        return process_failed("activity_not_available") unless Model.ready?(model)
        return process_failed("activity_not_supported") unless actor.can_perform_activity?(type, model.activity_pub_actor.ap_type)

        [actor, model]
      end
    end
  end
end
