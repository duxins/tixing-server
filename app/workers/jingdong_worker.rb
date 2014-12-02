require 'notification_helper'

class JingdongWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, unique: true

  def perform(id)
    product = Jingdong::Product.find_by_id(id)
    Rails.logger.info "[JD] #{product.id} - Started Fetch Product"
    current_price = Jingdong::Product.fetch_price(id)
    Rails.logger.info "[JD] #{product.id} - Fetched Price: #{current_price}"
    if current_price != product.price
      Rails.logger.info "[JD] #{product.id} - Price Updates Found: #{product.price} -> #{current_price}"

      product.update(price: current_price)
      Jingdong::Price.create(product: product, price: current_price)

      monitorings = Jingdong::Monitoring.includes(:user).where(product: product, disabled: false).where('? <= threshold', current_price)
      monitorings.each do |monitoring|
        Rails.logger.info "[JD] #{product.id} - Notify User: #{monitoring.user.id} (threshold: #{monitoring.threshold})"
        NotificationHelper.send ({
          user_id: monitoring.user.id,
          service_id: Jingdong::SERVICE_ID,
          title: '京东商城',
          message: "#{product.name}\n当前价格: ¥#{current_price}",
          push_message: "京东商城:您关注的商品 '#{product.name}' 价格降到 ¥#{current_price} 了 !",
          url: product.url,
          web_url: product.web_url,
          thumb: product.image,
        })
        monitoring.update(disabled: true)
      end
    end
    Rails.logger.info "[JD] #{product.id} - Completed"
  end
end