namespace :notification do
  task :debug, [:device_token] => :environment do |t, args|
    token = args[:device_token] || ''
    NotificationHelper.deliver('test message', token, 'default')
  end
end