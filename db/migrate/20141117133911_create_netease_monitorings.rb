class CreateNeteaseMonitorings < ActiveRecord::Migration
  def change
    create_table :netease_monitorings do |t|
      t.references :user, index: true
      t.string :keyword, index: true

      t.timestamps
    end
  end
end
