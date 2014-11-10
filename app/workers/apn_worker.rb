require 'apn_connection'

class APNWorker
  include Sidekiq::Worker

  APN_POOL = ConnectionPool.new(:size => 2, :timeout => 300) do
    APNConnection.new
  end

  def perform(message, token, sound, custom_data = nil)

    cache_key = "device:token:#{token}"

    if Rails.cache.read(cache_key)
      sound = nil
    end

    Rails.cache.write(cache_key, true, expires_in: 30.seconds)

    sound = "#{sound}.caf" if sound && sound != 'default'

    logger.info "to:#{token[0..10]}, message: #{message[0..20]}..., sound: #{sound}, id:#{custom_data['id']}"
    APN_POOL.with do |connection|
      notification = Houston::Notification.new(device: token)
      notification.alert = message
      notification.sound = sound if sound
      notification.custom_data = custom_data
      connection.write(notification.message)
    end
  end

end