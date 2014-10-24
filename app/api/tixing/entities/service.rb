module Tixing
  module Entities
    class Service < Grape::Entity
      expose :id
      expose :name
      expose :icon do |service, options|
        "#{options[:env]['rack.url_scheme']}://#{options[:env]['HTTP_HOST']}/icons/#{service.icon}" if service.icon
      end
      expose :url do |service, options|
        "#{options[:env]['rack.url_scheme']}://#{options[:env]['HTTP_HOST']}#{service.url}"
      end
    end
  end
end