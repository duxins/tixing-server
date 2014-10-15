class Weibo::User < ActiveRecord::Base
  has_many :followers, primary_key:'uid', foreign_key:'uid', class_name: "Weibo::Follower"
end
