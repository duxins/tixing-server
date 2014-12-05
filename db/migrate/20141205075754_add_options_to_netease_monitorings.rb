class AddOptionsToNeteaseMonitorings < ActiveRecord::Migration
  def change
    add_column :netease_monitorings, :options, :text
  end
end
