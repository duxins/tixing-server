class AddFollowersCountToWeiboUser < ActiveRecord::Migration
  def change
    add_column :weibo_users, :followers_count, :integer, default: 0

    Weibo::User.reset_column_information

    Weibo::User.all.each do|u|
      Weibo::User.reset_counters(u.id, :followers)
    end
  end
end
