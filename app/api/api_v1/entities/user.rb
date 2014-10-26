module APIv1
  module Entities
    class User < Grape::Entity
      expose :id
      expose :name
      expose :auth_token
      expose :sound
      expose :silent_at_night
      expose :devices, with: APIv1::Entities::Device
      expose :services, with: APIv1::Entities::Service
    end
  end
end