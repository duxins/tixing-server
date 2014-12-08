namespace :weibo do
  desc '抓取微博'
  task :run, [:important] => :environment do |t, args|
    important = args[:important]

    users = unless important
              Weibo::User.less_important
            else
              Weibo::User.important
            end

    users.each do |user|
      diff = DateTime.now.to_i - user.checked_at.to_i
      Rails.logger.info "[WEIBO] skip #{user.name} {diff: #{diff}, frequency: #{user.frequency}}" and next if user.frequency > diff
      WeiboWorker.perform_async user.id
    end
  end

  desc '删除没人关注的微博用户'
  task :cleanup => :environment do
    Rails.logger.info '[WEIBO] Started cleanup weibo users'
    users = Weibo::User.where(followers_count: 0).where('updated_at < ?', 15.minutes.ago)
    next if users.empty?
    users.each do |user|
      Rails.logger.info "[WEIBO] Delete user: ##{user.id} - #{user.name}"
      user.destroy
    end
  end
end
