class Weibo::Follower < ActiveRecord::Base
  belongs_to :weibo_user, primary_key: 'uid', foreign_key: 'uid', class_name: "Weibo::User", counter_cache: 'followers_count'
  belongs_to :user, class_name: '::User'

  validate on: :create do
    errors.add(:base, :taken) if Weibo::Follower.where(uid: self.uid, user_id: self.user_id).present?
  end

end
