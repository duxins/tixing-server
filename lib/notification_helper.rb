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
    return unless Installation.exists?(user_id: user_id, service_id: service_id)

    notification = Notification.create(user: user, service_id:service_id, thumb: thumb, url: url, title: title, message: message)
    return unless notification


    devices = user.devices
    devices.each do |device|
      sound = if user.silent_at_night? and device.at_night?
                nil
              else
                user.sound
              end

      APNWorker.perform_async(push_message, device['token'], sound, {id: notification.id})
    end

  end
end