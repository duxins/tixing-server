class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message, limit: 1000
      t.string :sound
      t.references :user, index: true

      t.datetime :deleted_at
      t.timestamps
    end
    add_index :notifications, :deleted_at
  end
end
