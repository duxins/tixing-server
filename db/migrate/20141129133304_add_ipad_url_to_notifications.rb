class AddIpadUrlToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :ipad_url, :string
  end
end
