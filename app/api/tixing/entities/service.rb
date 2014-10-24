module Tixing
  module Entities
    class Service < Grape::Entity
      expose :id
      expose :name
      expose :icon
      expose :url do |service, options|
        "#{options[:env]['rack.url_scheme']}://#{options[:env]['HTTP_HOST']}#{service.url}"
      end

    end
  end
end