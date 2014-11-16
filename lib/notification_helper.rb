class NotificationHelper

  def self.send(data = {})
    user_id = data[:user_id]
    service_id = data[:service_id]
    title = data[:title] || '消息提醒'
    message = data[:message]
    push_message = data[:push_message] || "#{title}:#{message}"
    thumb = data[:thumb] || ''
    url = data[:url] || ''

    user = User.find_by_id(user_id)

    return unless user
    return unless installation = user.installations.where(service_id: service_id).first

    notification = Notification.create(user: user, service_id:service_id, thumb: thumb, url: url, title: title, message: message)
    return unless notification

    sound = installation.preferences[:sound] || user.sound

    devices = user.devices
    devices.each do |device|
      sound = if user.silent_at_night? and device.at_night?
                nil
              else
                sound
              end

      self.deliver(push_message, device['token'], sound, {id: notification.id})
    end

  end

  def self.deliver(message, token, sound, custom_data = {})
    cache_key = "device:token:#{token}"

    if Rails.cache.read(cache_key)
      sound = nil
    else
      Rails.cache.write(cache_key, true, expires_in: 30.seconds)
    end

    sound = "#{sound}.caf" if sound && sound != 'default'

    Rails.logger.info "[APN] sent to #{token[0..10]}, message: #{message[0..10]}.., sound: #{sound}, data: #{custom_data}"

    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name('ios')
    n.device_token = token
    n.alert = message
    n.sound = sound if sound
    n.data = custom_data
    n.save!
  end
end