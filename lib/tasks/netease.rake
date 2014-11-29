require 'notification_helper'

namespace :netease do
  task :run, [:priority] => :environment do |t, args|
    priority = args[:priority] || 'all'
    matches = Netease::Monitoring.check(priority: priority.to_sym)

    matches.each do |match|
      users = match[:users]
      news = match[:news]

      users.each do |user|
        NotificationHelper.send(
          service_id: Netease::SERVICE_ID,
          user_id: user,
          thumb: 'https://tixing.io/icons/netease.png',

          title: '网易新闻',
          message: "#{news['title']} #{news['digest']}",
          push_message: "网易新闻: #{news['title']} #{news['digest']} 详情 >>",

          url: "newsapp://doc/#{news['docid']}",
          web_url: news['url']
        )
      end
    end

  end
end


