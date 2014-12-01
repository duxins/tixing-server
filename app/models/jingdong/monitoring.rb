class Jingdong::Monitoring < ActiveRecord::Base
  belongs_to :product, class_name: 'Jingdong::Product', counter_cache: true
  belongs_to :user, class_name: '::User'
end
