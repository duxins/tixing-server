require 'notification_helper'

namespace :jingdong do
  desc '开始抓取京东商城价格'
  task :run => :environment do
    products =  Jingdong::Product.available.pluck(:id)
    return if products.empty?
    products.each do |id|
      JingdongWorker.perform_async(id)
    end
  end

  desc '清理商品'
  task :cleanup => :environment do
    Rails.logger.info "[JD] Started cleanup"
    products = Jingdong::Product.where(monitorings_count: 0).where('updated_at <= ?', 2.hours.ago)
    Rails.logger.info "[JD] Found #{products.count} orphan products" if products.present?
    products.each do |product|
      product.destroy
      Rails.logger.info "[JD] Deleted product: #{product.id}"
    end
    Rails.logger.info "[JD] Completed"
  end
end

