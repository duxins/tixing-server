module APIv1
  module Entities
    class Notification < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      expose :id
      expose :message
      expose :service, with: APIv1::Entities::Service

      expose :created_at, format_with: :iso_timestamp

    end
  end
end