module Tixing
  module Entities
    class Service < Grape::Entity
      expose :id
      expose :name
      expose :icon
    end
  end
end