module Tixing
  class API < Grape::API
    format :json
    prefix 'api'
    helpers Tixing::Helpers
    mount Users
    mount Devices
    mount Services
    mount Notifications

    route :any, '*path' do
      error!({ error: 'Not Found', code: 404})
    end

  end
end