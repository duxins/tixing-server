module APIv1
  module Entities
    class Notification < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      expose :id
      expose :title
      expose :message
      expose :highlight
      expose :thumb

      expose :url do |notification, options|
        if options[:env]['HTTP_USER_AGENT'] =~ /iPad/ and notification.ipad_url.present?
          notification.ipad_url
        else
          notification.url
        end
      end

      expose :web_url
      expose :service, with: APIv1::Entities::Service

      expose :created_at, format_with: :iso_timestamp

    end
  end
end