class Jingdong::Monitoring < ActiveRecord::Base
  belongs_to :product, class_name: 'Jingdong::Product', counter_cache: true
  belongs_to :user, class_name: '::User'

  validates :threshold, presence:true, numericality: { greater_than: 0}

  validate on: :create do
    errors.add(:base, :too_many, limit: 10) if Jingdong::Monitoring.where(user_id: self.user_id).count >= 10
  end

end
