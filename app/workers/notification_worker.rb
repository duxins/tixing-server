class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: :false

  def perform(user_id, service_id, message)
    user = User.find_by_id(user_id)
    return unless user
    return unless user.services.pluck(:id).include?(service_id)

    Notification.create(user: user, message: message, service_id: service_id)

    devices = user.devices
    devices.each do |device|
      if user.silent_at_night? and device.at_night?
        sound = nil
      else
        sound = user.sound
      end
      APNWorker.perform_async(message, device['token'], sound)
    end
  end

end
