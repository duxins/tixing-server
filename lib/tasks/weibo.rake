namespace :weibo do
  desc '开始抓取微博'
  task :run => :environment do
    Weibo::User.available.each do |user|
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
