module Tixing
  module Entities
    class User < Grape::Entity
      expose :id
      expose :name
      expose :auth_token
      expose :sound
      expose :silent_at_night
      expose :devices, with: Tixing::Entities::Device
      expose :services, with: Tixing::Entities::Service
    end
  end
end