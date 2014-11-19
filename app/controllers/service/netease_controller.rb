class Service::NeteaseController < Service::BaseServiceController
  before_action :authorize!

  def index
    @keywords = Netease::Monitoring.where(user: current_user)
    if params[:partial]
      render partial: 'keyword'
    end
  end

  def create
    begin
      @keyword = Netease::Monitoring.new(keyword: params[:keyword], user: current_user)
      raise @keyword.errors.full_messages.first unless @keyword.save
      render nothing: true
    rescue => e
      render json: {error: {message: e.message }}
    end
  end

  def destroy
    Netease::Monitoring.where(id: params[:id], user: current_user).destroy_all
    render nothing: true
  end
end
