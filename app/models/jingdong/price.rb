class Jingdong::Price < ActiveRecord::Base
  belongs_to :product, class_name: 'Jingdong::Product'
end
