class Weibo::Follower < ActiveRecord::Base
  belongs_to :weibo_user, primary_key: 'uid', foreign_key: 'uid', class_name: "Weibo::User"
  belongs_to :user
end
