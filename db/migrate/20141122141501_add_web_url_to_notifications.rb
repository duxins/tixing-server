class AddWebUrlToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :web_url, :string
  end
end
