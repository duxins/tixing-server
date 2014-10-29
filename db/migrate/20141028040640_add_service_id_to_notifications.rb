class AddServiceIdToNotifications < ActiveRecord::Migration
  def change
    add_reference :notifications, :service, index: true
  end
end
