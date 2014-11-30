class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def admin?
    ENV['admin_token'].present? && request.headers['HTTP_ADMINTOKEN'] == ENV['admin_token']
  end
end
