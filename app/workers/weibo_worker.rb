require 'notification_helper'

class WeiboWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, unique: true

  def perform(id)
    weibo_user = Weibo::User.find(id)
    feeds = weibo_user.fetch_new_feeds
    return if feeds.empty?

    followers = weibo_user.followers
    weibo_user.update(last_checked_at: DateTime.now, last_weibo_id: feeds.last['mid'])

    feeds.each do |feed|
       push_message = "#{weibo_user['name']}发微博了: #{feed['text']}"

       followers.each do |follower|
           NotificationHelper.send ({
               user_id: follower['user_id'],
            service_id: Weibo::SERVICE_ID,
                 title: weibo_user.name,
               message: feed['text'],
          push_message: push_message,
                 thumb: weibo_user['avatar']
           })
       end
    end

  end

end