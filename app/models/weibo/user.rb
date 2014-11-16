require 'open-uri'

class Weibo::User < ActiveRecord::Base
  has_many :followers, primary_key:'uid', foreign_key:'uid', class_name: "Weibo::Follower"
  scope :available, lambda { where('followers_count >?', 0).order('followers_count DESC') }

  def followed_by?(user)
    self.followers.where(user: user).present?
  end

  def fetch_new_feeds
    url = ENV['weibo_api'] + "/feed/#{self.uid}"
    since = self.last_weibo_id
    url += "?since=#{since}" if since

    begin
      Rails.logger.info("Request #{url}")

      feeds = Weibo::User.request_api(url)

      return [] if feeds.empty?

      Rails.logger.info("Feeds: #{feeds.map{|x| x['mid']}}")

      feeds.select!{|feed| feed['mid'] > self.last_weibo_id.to_i}
      feeds.sort_by!{|feed| feed['mid']}
    rescue => e
      Rails.logger.error("Weibo API error (feed/#{self.uid}) :#{e.message}")
      return []
    end
  end

  def self.request_api(url)
    json = Timeout::timeout(5) do
      Curl::Easy.perform(url) do |curl|
        curl.connect_timeout = 5
      end.body_str
    end
    JSON.parse(json)
  end

  def self.fetch_weibo_user(name)
    url = %[#{ENV['weibo_api']}/user/#{URI.escape(name)}]
    begin
      weibo_user = Weibo::User.request_api(url)
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
