class AddPriorityToWeiboUsers < ActiveRecord::Migration
  def change
    add_column :weibo_users, :priority, :integer, default:0, after: :metadata
  end
end
