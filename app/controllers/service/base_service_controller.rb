class Service::BaseServiceController < ApplicationController
  helper_method :current_user

private
  def authorize!
    raise 'Not Authorized!' if current_user.nil?
  end

  def current_user
    @current_user ||= User.find(user_id) if user_id
  end

  def user_id
    if request.headers['HTTP_AUTHTOKEN']
      session[:user_id] = User.find_by_auth_token(request.headers['HTTP_AUTHTOKEN']).id
    else
      session[:user_id]
    end
  end
end