module Tixing
  module Entities
    class User < Grape::Entity
      expose :id
      expose :email
      expose :auth_token
      expose :sound
      expose :devices, with: Device
      expose :services, with: Service
    end
  end
end