class RenameLastCheckedAtToCheckedAt < ActiveRecord::Migration
  def change
    rename_column :weibo_users, :last_checked_at, :checked_at
  end
end
