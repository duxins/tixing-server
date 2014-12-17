class ChangeDefaultOfNotifications < ActiveRecord::Migration
  def up
    change_column_default :notifications, :web_url, ''
    change_column_default :notifications, :ipad_url, ''
    change_column_default :notifications, :url, ''
    change_column_default :notifications, :thumb, ''

    execute("UPDATE notifications SET web_url = '' WHERE web_url IS NULL")
    execute("UPDATE notifications SET url = '' WHERE url IS NULL")
    execute("UPDATE notifications SET ipad_url = '' WHERE ipad_url IS NULL")
    execute("UPDATE notifications SET thumb = '' WHERE thumb IS NULL")
  end

  def down
  end
end
