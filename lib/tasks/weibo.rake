namespace :weibo do
  desc 'Start weibo sidekiq worker'
  task :run => :environment do
    Weibo::User.available.each do |user|
      WeiboWorker.perform_async(user.id)
    end
  end
end