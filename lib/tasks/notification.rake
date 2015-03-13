namespace :notification do
  task :debug, [:device_token] => :environment do |t, args|
    token = args[:device_token] || ''
    NotificationHelper.deliver('test message', token, 'default')
  end

  task :send, [:user_id, :message] => :environment do |t, args|
    user_id = args[:user_id]
    message = args[:message]
    NotificationHelper.notify user_id, message
  end
end