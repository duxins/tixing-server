class Jingdong::Price < ActiveRecord::Base
  belongs_to :product, class_name: 'Jingdong::Product'
  validates :price, presence: true, numericality: {greater_than: 0}
end
