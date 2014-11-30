class Weibo::Follower < ActiveRecord::Base
  belongs_to :weibo_user, primary_key: 'uid', foreign_key: 'uid', class_name: "Weibo::User", counter_cache: 'followers_count'
  belongs_to :user, class_name: '::User'
end
