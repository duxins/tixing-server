module APIv1
  class API < Grape::API
    format :json
    prefix 'api'
    helpers APIv1::Helpers
    mount Users
    mount Devices
    mount Services
    mount Notifications
    mount Misc

    route :any, '*path' do
      error!({ error: 'Not Found', code: 404})
    end

  end
end