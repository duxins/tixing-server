class Service::WeiboController < Service::BaseServiceController
  before_action :authorize!
  # skip_before_filter :verify_authenticity_token

  def index
  end

  def following
    following = Weibo::Follower.includes(:weibo_user).where(user: current_user).map(&:weibo_user)
    render json:[] if following.nil?
    render json:following.as_json(only: [:id, :name, :avatar])
  end

  def follow
    begin
      raise '你关注的人已经够多啦！' if Weibo::Follower.where(user:current_user).count > 5
      @user = Weibo::User.fetch_weibo_user(params[:name])
      raise '你已经关注过该用户' if @user.followed_by?(current_user)
      Weibo::Follower.create(user: current_user, weibo_user: @user)
      render json: @user.as_json(only: [:id, :name, :avatar])
    rescue => e
      render json: {error: {message: e.message} }
    end
  end

  def unfollow
    @user = Weibo::User.find_by_id(params[:id])
    @user.followers.where(user: current_user).destroy_all()
    render json: {}
  end

private

end
