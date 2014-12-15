class ChangeColumnCharset < ActiveRecord::Migration
  def up
    execute('ALTER TABLE notifications MODIFY `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;')
    execute('ALTER TABLE notifications MODIFY `message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;')

    execute('ALTER TABLE rpush_notifications MODIFY `alert` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;')
  end

  def down
    execute('ALTER TABLE notifications MODIFY `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci;')
    execute('ALTER TABLE notifications MODIFY `message` varchar(1000) CHARACTER SET utf8 COLLATE utf8_unicode_ci;')

    execute('ALTER TABLE rpush_notifications MODIFY `alert` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci;')
  end
end
