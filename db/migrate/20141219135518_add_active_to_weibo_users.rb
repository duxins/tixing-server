class AddActiveToWeiboUsers < ActiveRecord::Migration
  def change
    add_column :weibo_users, :active, :boolean, default: true
  end
end
