class AddIndexToWeiboFollowers < ActiveRecord::Migration
  def change
    add_index :weibo_followers, [:uid, :user_id], unique: true
  end
end
