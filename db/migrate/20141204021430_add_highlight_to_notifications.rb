class AddHighlightToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :highlight, :string
  end
end
