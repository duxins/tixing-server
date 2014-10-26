module APIv1
  module Entities
    class Notification < Grape::Entity
      expose :id
      expose :message
    end
  end
end