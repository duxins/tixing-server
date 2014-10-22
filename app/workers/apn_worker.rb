require 'apn_connection'

class APNWorker
  include Sidekiq::Worker

  APN_POOL = ConnectionPool.new(:size => 2, :timeout => 300) do
    APNConnection.new
  end

  def perform(message, token, custom_data = nil)
    logger.info "to:#{token}, message: #{message}"

    APN_POOL.with do |connection|
        notification = Houston::Notification.new(device: token)
        notification.alert = message
        notification.sound = 'default'
        notification.custom_data = custom_data
        connection.write(notification.message)
    end
  end

end