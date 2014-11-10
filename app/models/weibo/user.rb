require 'open-uri'

class Weibo::User < ActiveRecord::Base
  has_many :followers, primary_key:'uid', foreign_key:'uid', class_name: "Weibo::Follower"
  scope :available, lambda { where('followers_count >?', 0).order('followers_count DESC') }

  def followed_by?(user)
    self.followers.where(user: user).present?
  end

  def self.fetch_weibo_user(name)
    api_url = %[#{ENV['weibo_api']}/user/#{URI.escape(name)}]
    begin
      json = Timeout::timeout(5) do
        open(api_url).read
      end
      weibo_user = JSON.parse(json)
      self.save_weibo_user(weibo_user)
    rescue => e
      Rails.logger.error("Weibo API error (/user/#{name}): #{e.message}")

      raise '没有找到该用户' if e.message =~ /404/
      raise '系统繁忙，请稍后再试'
    end
  end

  def self.weibo_user_cache_key(name)
    "service:weibo:user:#{name}"
  end

  def self.save_weibo_user(weibo_user)
    user = Weibo::User.find_or_initialize_by(uid: weibo_user['id'])
    user.name = weibo_user['name']
    user.avatar = weibo_user['avatar']
    user.metadata = weibo_user.to_yaml
    if user.new_record?
      user.last_weibo_id = weibo_user['mid']
      user.last_checked_at = DateTime.now
    end
    user.save
    user
  end

end
