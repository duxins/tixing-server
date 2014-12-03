require 'notification_helper'

class ShunfengWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, unique: true

  def perform(id)
    product = Shunfeng::Product.find_by_id(id)
    Rails.logger.info "[SF] #{product.id} - Started Fetch Product: #{product.price}"
    current_price = Shunfeng::Product.fetch_price(product.sku)
    Rails.logger.info "[SF] #{product.id} - Fetched Price: #{current_price}"
    return unless (current_price - product.price).abs > 0.01
    Rails.logger.info "[SF] #{product.id} - Price Updates Found: #{product.price} -> #{current_price}"
    product.update(price: current_price)

    monitorings = Shunfeng::Monitoring.includes(:user).where(product: product, disabled: false).where('? <= threshold', current_price)
    monitorings.each do |monitoring|
      Rails.logger.info "[SF] #{product.id} - Notify User: #{monitoring.user.id} (threshold: #{monitoring.threshold})"
      NotificationHelper.send ({
        user_id: monitoring.user.id,
        service_id: Shunfeng::SERVICE_ID,
        title: '顺丰优选',
        message: "#{product.name}\n当前价格: ¥#{current_price}",
        push_message: "顺丰优选: 您关注的商品 \"#{product.name}\" 价格降到 ¥#{current_price} 了 !",
        url: product.url,
        thumb: product.thumb
      })
      monitoring.update(disabled: true)
    end
    Rails.logger.info "[SF] #{product.id} - Completed"
  end
end