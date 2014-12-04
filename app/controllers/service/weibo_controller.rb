class Service::WeiboController < Service::BaseServiceController
  before_action :authorize!
  rescue_from Weibo::User::NotFound, with: :show_errors
  rescue_from Weibo::User::APIError, with: :show_errors
  rescue_from ActiveRecord::RecordInvalid, with: :show_errors

  def index
    if params[:partial]
      @following = Weibo::Follower.includes(:weibo_user).where(user: current_user).map(&:weibo_user).compact
      render partial: 'user_list'
    end
  end

  def follow
    @user = Weibo::User.fetch_weibo_user(params[:name])
    @user.followers.create!(user: current_user)
    render nothing: true
  end

  def unfollow
    @user = Weibo::User.find_by_id(params[:id])
    @user.followers.where(user: current_user).destroy_all()
    render nothing: true
  end

private
  def show_errors(exception)
    error = case exception.class.to_s
                when 'Weibo::User::NotFound'
                  '没有找到该用户'
                when 'ActiveRecord::RecordInvalid'
                  exception.record.errors.full_messages.first
                else
                  '系统繁忙，请稍后再试'
              end
    render json: {error: {message: error}}
  end
end
