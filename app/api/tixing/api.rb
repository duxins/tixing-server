module Tixing
  class API < Grape::API
    format :json
    prefix 'api'

    helpers Tixing::Helpers

    get '/' do
      authenticate!
    end

  end
end