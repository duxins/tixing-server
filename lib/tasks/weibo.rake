namespace :weibo do
  desc '抓取微博'
  task :run, [:priority] => :environment do |t, args|
    priority = args[:priority] || 'all'

    range = case priority
              when 'low'
                1..10
              when 'high'
                10..10000
              else
                1..10000
            end

    users = Weibo::User.where(followers_count: range)
    users.each do |user|
      WeiboWorker.perform_async(user.id)
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
