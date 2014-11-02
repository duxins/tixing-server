class AddTitleToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :title, :string, after: :id
    add_column :notifications, :thumb, :string, after: :message
    add_column :notifications, :url, :string, after: :thumb
  end
end
