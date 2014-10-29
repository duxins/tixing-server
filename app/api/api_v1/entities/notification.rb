module APIv1
  module Entities
    class Notification < Grape::Entity
      expose :id
      expose :message
      expose :service, with: APIv1::Entities::Service
    end
  end
end