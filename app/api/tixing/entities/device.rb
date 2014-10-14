module Tixing
  module Entities
    class Device < Grape::Entity
      expose :id
      expose :name
      expose :created_at
      expose :updated_at
    end
  end
end