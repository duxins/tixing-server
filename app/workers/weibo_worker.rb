class WeiboWorker
  include Sidekiq::Worker

  def perform(id)
    user = Weibo::User.find(id)
    since = user.last_weibo_id
    followers = user.followers
    return if followers.count == 0

    url = ENV['weibo_spider_url'] + '/feed/' + user.uid
    url += "?since=#{since}" if since

    http = Curl.get(url).body_str
    feeds = JSON.parse(http)

    feeds.sort_by!{|feed| feed['mid']}

    feeds.each do |feed|
       user.update(last_checked_at: DateTime.now, last_weibo_id: feed['mid'])
       followers.each do |follower|
         NotificationWorker.perform_async(follower['user_id'], 1, feed['text'])
       end
    end

  end

end