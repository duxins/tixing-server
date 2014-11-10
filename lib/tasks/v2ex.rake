require 'notification_helper'

$cache = {}

def send_notification (monitoring, topic)
  cache_key = "#{monitoring['user_id']}:#{topic['id']}"
  return if $cache.has_key? cache_key
  $cache[cache_key] = 1

  NotificationHelper.send ({user_id: monitoring['user_id'],
                         service_id: V2ex::SERVICE_ID,
                              thumb: 'https://www.v2ex.com/static/apple-touch-icon.png',
                            message: topic['title'],
                                url: topic['url'],
                              title: 'V2EX'})
end

namespace :v2ex do
  task :run => :environment do
    topics = V2ex::Monitoring.fetch_recent_topics
    exit if topics.empty?

    V2ex::Monitoring.select(:id, :user_id, :keyword).find_in_batches do |group|
      group.each do |monitoring|

        keyword = monitoring['keyword']
        next if keyword.length == 0

        topics.each do |topic|
          title = topic['title'].downcase
          send_notification(monitoring, topic) if title.include?(keyword)
        end

      end #/group
    end
  end
end


