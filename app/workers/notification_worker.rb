class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: :false

  def perform(user_id, service_id, message)
    user = User.includes(:installations).joins(:installations).where(id: user_id, installations: {service: service_id}).first
    return unless user

    Notification.create(user: user, message: message)

    devices = user.devices
    devices.each do |device|
      APNWorker.perform_async(message, device['token'])
    end
  end

end
