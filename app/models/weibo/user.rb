class Weibo::User < ActiveRecord::Base
  class NotFound < StandardError; end
  class APIError < StandardError; end

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
          bindings[:view].link_to( bindings[:object].url, target: '_blank') do
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
      feeds = Weibo::User.request_api(url)
      return [] if feeds.empty?

      Rails.logger.info("Feeds: #{feeds.map{|x| x['mid']}}")

      feeds.select!{|feed| feed['mid'] > self.last_weibo_id.to_i}
      feeds.sort_by!{|feed| feed['mid']}
    rescue => e
      Rails.logger.error("[WEIBO] #{e.message}")
      Rails.logger.error("Weibo API error (feed/#{self.uid}) :#{e.message}")
      return []
    end
  end

  def self.request_api(url)
    Rails.logger.info "[WEIBO] Request API: #{url}"
    json_str = Timeout::timeout(10) do
      Curl::Easy.perform(url) do |curl|
        curl.connect_timeout = 10
      end.body_str
    end

    JSON.parse(json_str)
  end

  def self.fetch_weibo_user(name)
    name.strip!
    url = %[#{ENV['weibo_api']}/user/#{URI.escape(name)}]
    Rails.logger.info "[WEIBO] Started fetch user: #{name}"

    user = self.find_by_name(name)
    if user.present? and user.updated_at > 5.minutes.ago
      Rails.logger.info "[WEIBO] User #{name} exists"
      return user
    end

    begin
      weibo_user = self.request_api(url)
      Rails.logger.info "[WEIBO] Fetched: #{weibo_user.select {|k| ['id', 'name'].include? k}}"
      self.save_weibo_user weibo_user
    rescue => e
      Rails.logger.error "[WEIBO] Error: #{e.message}"
      raise NotFound if e.message =~ /404/
      raise APIError.new(e.message)
    end
  end

  def self.save_weibo_user(weibo_user)
    user = self.find_or_initialize_by(uid: weibo_user['id'])
    user.name = weibo_user['name']
    user.avatar = weibo_user['avatar']
    user.metadata = weibo_user.to_yaml

    if user.new_record?
      user.last_weibo_id = weibo_user['mid']
      user.last_checked_at = DateTime.now
    end
    user.save
    user.touch
    user
  end

  def url
    "http://weibo.com/u/#{self.uid}"
  end

end
