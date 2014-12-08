class ChangeStringToDatetimeInWeiboUsers < ActiveRecord::Migration
  def change
    change_column :weibo_users, :deleted_at, :datetime
    change_column :weibo_users, :last_checked_at, :datetime
  end
end
