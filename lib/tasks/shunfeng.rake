namespace :shunfeng do
  desc '抓取顺丰优选价格'
  task :run => :environment do
    products =  Shunfeng::Product.available.pluck(:id)
    next if products.empty?
    products.each do |id|
      ShunfengWorker.perform_async(id)
    end
  end

  desc '清理商品'
  task :cleanup => :environment do
    Rails.logger.info "[SF] Started cleanup"
    products = Shunfeng::Product.where(monitorings_count: 0).where('updated_at <= ?', 2.hours.ago)
    Rails.logger.info "[SF] Found #{products.count} orphan products" if products.present?
    products.each do |product|
      product.destroy
      Rails.logger.info "[SF] Deleted product: #{product.id}"
    end
    Rails.logger.info "[SF] Completed"
  end
end