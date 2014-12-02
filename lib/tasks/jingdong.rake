require 'notification_helper'

namespace :jingdong do
  task :run => :environment do
    products =  Jingdong::Product.available.pluck(:id)
    return if products.empty?
    products.each do |id|
      JingdongWorker.perform_async(id)
    end
  end
end

