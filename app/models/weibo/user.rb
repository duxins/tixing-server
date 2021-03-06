class Weibo::User < ActiveRecord::Base
  class NotFound < StandardError; end
  class APIError < StandardError; end

  has_many :followers, primary_key:'uid', foreign_key:'uid', class_name: "Weibo::Follower", dependent: :destroy
  scope :available, lambda { where('followers_count >?', 0).where(active: true).order('followers_count DESC') }

  scope :important, lambda { where(active: true).where('priority = ? or followers_count BETWEEN ? AND ?', priorities[:high], 10, 100000).order(followers_count: :desc)}
  scope :less_important, lambda { where(active: true).where(followers_count: 1..10).where.not(priority: priorities[:high]).order(followers_count: :desc) }

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
      field :active do
        column_width 70
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

      field :posted_at
      field :checked_at
      field :created_at
    end

    edit do
      field :active do
      end
    end
  end

  def fetch_feeds
    url = ENV['weibo_api'] + "/feed/#{self.uid}"
    Rails.logger.info "[WEIBO] [##{self.uid} - #{self.name}] Started fetch feeds"

    since = self.last_weibo_id
    url += "?since=#{since}" if since

    begin
      feeds = Weibo::User.request_api(url)
      self.update(checked_at: DateTime.now)
      feeds.select! do |feed|
        feed['mid'] > self.last_weibo_id.to_i and DateTime.parse(feed['created_at']) > 80.minutes.ago
      end
      return [] if feeds.empty?
      Rails.logger.info "[WEIBO] [##{self.uid} - #{self.name}] Fetched #{feeds.count} feeds"
      feeds.sort_by!{|feed| feed['mid']}
      self.update(last_weibo_id: feeds.last['mid'], posted_at: DateTime.parse(feeds.last['created_at']))
      feeds
    rescue => e
      Rails.logger.error("[WEIBO] Error: [##{self.uid} - #{self.name}] #{e.message}")
      return []
    end
  end

  def self.request_api(url)
    Rails.logger.info "[WEIBO] Request API: #{url}"

    begin
      curl = Timeout::timeout(10) do
        Curl::Easy.perform(url) do |c|
        end
      end
    rescue => e
      raise APIError.new(e.message)
    end

    raise NotFound if curl.status =~ /404/

    begin
      json_str = curl.body_str
      json = JSON.parse(json_str)
    rescue JSON::ParserError => e
      raise APIError.new(e.message)
    end

    raise APIError.new(json_str) if json.is_a? Hash and json.has_key? 'error'
    json
  end

  def self.fetch_weibo_user(name)
    name.strip!
    url = %[#{ENV['weibo_api']}/user/#{URI.escape(name)}]
    Rails.logger.info "[WEIBO] Started fetch user: #{name}"

    user = self.find_by_name(name)
    if user.present? and user.updated_at > 60.minutes.ago
      Rails.logger.info "[WEIBO] User #{name} exists"
      return user
    end

    begin
      weibo_user = self.request_api(url)
      Rails.logger.info "[WEIBO] Fetched: #{weibo_user.select {|k| ['id', 'name'].include? k}}"
      self.save_weibo_user weibo_user
    rescue => e
      Rails.logger.error "[WEIBO] Error: #{e.message}"
      raise e
    end
  end

  def self.save_weibo_user(weibo_user)
    user = self.find_or_initialize_by(uid: weibo_user['id'])
    user.name = weibo_user['name']
    user.avatar = weibo_user['avatar']
    user.metadata = weibo_user.to_yaml

    if user.new_record?
      user.last_weibo_id = weibo_user['mid']
      user.checked_at = DateTime.now
      user.posted_at = DateTime.parse(weibo_user['feed_created_at']) if weibo_user['feed_created_at']
    end
    user.save
    user.touch
    user
  end

  # 根据上次微博更新时间计算抓取频率
  def frequency
    return 60.minutes if self.posted_at.nil?

    if self.posted_at    < 365.days.ago
      80.minutes
    elsif self.posted_at < 90.days.ago
      60.minutes
    elsif self.posted_at < 30.days.ago
      30.minutes
    elsif self.posted_at < 5.days.ago
      15.minutes
    elsif self.posted_at < 2.days.ago
      10.minutes
    else
      3.minutes
    end
  end

  def url
    "http://weibo.com/u/#{self.uid}"
  end

end
