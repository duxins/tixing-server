module APIv1
  class API < Grape::API
    format :json
    prefix 'api'

    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response({ message: "Not Found", status: 404 })
    end

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