class Service::V2exController < Service::BaseServiceController
  before_action :authorize!

  skip_before_filter :verify_authenticity_token

  def index
    @keywords = V2ex::Monitoring.where(user: current_user).select('id, keyword')
    if params[:partial]
      render partial: 'keyword'
    end
  end

  def create
    begin
      raise '最多设置10条关键字' if V2ex::Monitoring.where(user: current_user).count > 10

      render nothing: true and return if V2ex::Monitoring.exists?(user:current_user, keyword: params[:keyword])

      @keyword = V2ex::Monitoring.new(keyword: params[:keyword], user: current_user)
      if @keyword.save
        render nothing: true
      else
        raise @keyword.errors.full_messages.join
      end

    rescue => e
      render json: {error: {message: e.message }}
    end
  end

  def destroy
    V2ex::Monitoring.where(id: params[:id], user: current_user).destroy_all
    render nothing: true
  end
end
