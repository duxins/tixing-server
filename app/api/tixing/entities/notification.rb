module Tixing
  module Entities
    class Notification < Grape::Entity
      expose :id
      expose :message
    end
  end
end