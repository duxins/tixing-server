require 'open-uri'

class Weibo::User < ActiveRecord::Base
  has_many :followers, primary_key:'uid', foreign_key:'uid', class_name: "Weibo::Follower", dependent: :destroy
  scope :available, lambda { where('followers_count >?', 0).order('followers_count DESC') }

  enum priority: [:low, :medium, :high]

  rails_admin do
    list do
      field :id do
        column_width 80
      end
      field :uid do
        column_width 100
      end

      field :name do
        formatted_value do
          bindings[:view].link_to( "http://www.weibo.com/u/" + bindings[:object].uid.to_s, target: '_blank') do
            bindings[:view].tag(:img , src: bindings[:object].avatar, width: 20) << " #{value}"
          end
        end
      end

      field :followers_count do
        column_width 50
      end

      field :priority do
        column_width 80
      end

      field :last_weibo_id do
        column_width 140
      end

      field :last_checked_at
      field :created_at
    end
  end

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
    json = Timeout::timeout(10) do
      Curl::Easy.perform(url) do |curl|
        curl.connect_timeout = 10
      end.body_str
    end
    JSON.parse(json)
  end

  def self.fetch_weibo_user(name)
    url = %[#{ENV['weibo_api']}/user/#{URI.escape(name)}]
    begin
      Rails.cache.fetch(self.weibo_user_cache_key(name)) do
        weibo_user = Weibo::User.request_api(url)
        self.save_weibo_user(weibo_user)
      end
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

    if weibo_user['followers_count'] > 10000
      user.priority = :high
    elsif weibo_user['followers_count'] > 1000
      user.priority = :medium
    else
      user.priority = :low
    end

    if user.new_record?
      user.last_weibo_id = weibo_user['mid']
      user.last_checked_at = DateTime.now
    end
    user.save
    Rails.cache.write(self.weibo_user_cache_key(user.name), user, expires_in:10.minutes)
    user
  end

end
