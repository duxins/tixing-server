module APIv1
  module Entities
    class Service < Grape::Entity
      expose :id
      expose :name
      expose :icon do |service, options|
        "#{options[:env]['rack.url_scheme']}://#{options[:env]['HTTP_HOST']}/icons/#{service.icon}" if service.icon
      end
      expose :url do |service, options|
        "#{options[:env]['rack.url_scheme']}://#{options[:env]['HTTP_HOST']}#{service.url}"
      end

      expose :sound, if: {type: :installed} do |service, options|
        sound = preferences[:sound] if preferences
        sound || options[:current_user].sound
      end

      expose :enabled, if: {type: :installed} do |service, options|
        service.enabled
      end

      expose :description

      def preferences
        @preferences ||= YAML.load(object.preferences) if object.preferences
      end

    end
  end
end