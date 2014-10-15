class APNConnection
  def initialize
    setup
  end

  def setup
    @uri = Rails.env.production? ? Houston::APPLE_PRODUCTION_GATEWAY_URI : Houston::APPLE_DEVELOPMENT_GATEWAY_URI
    @certificate = File.read("#{Rails.root}/config/apn_certificate.pem")

    @connection = Houston::Connection.new(@uri, @certificate, nil)
    @connection.open
  end

  def write(data)
    begin
      raise "Connection is closed" unless @connection.open?
      @connection.write(data)
    rescue Exception => e
      attempts ||= 0
      attempts += 1

      if attempts < 5
        setup
        retry
      else
        raise e
      end
    end
  end

end