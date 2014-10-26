module APIv1
  module Helpers

    def authenticate!
      current_user or error! ({code: 1000, error: 'Authorization failed.'})
    end

    def current_user
      return unless auth_token
      @current_user ||= User.find_by_auth_token(auth_token)
    end

    def auth_token
      @auth_token = request.headers['Auth-Token'] || params[:auth_token]
    end

  end
end