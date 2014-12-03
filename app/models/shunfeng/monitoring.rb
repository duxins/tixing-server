class Shunfeng::Monitoring < ActiveRecord::Base
  belongs_to :user, class_name: "::User"
  belongs_to :product, class_name: 'Shunfeng::Product', counter_cache: true
  default_scope ->{order(id: :desc)}

  validates :threshold, presence:true, numericality: { greater_than: 0}

end
