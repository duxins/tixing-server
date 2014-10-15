class CreateWeiboUsers < ActiveRecord::Migration
  def change
    create_table :weibo_users do |t|

      t.integer :uid, limit: 8

      t.string :name
      t.string :avatar
      t.text :metadata

      t.string :last_weibo_id
      t.string :last_checked_at

      t.string :deleted_at
      t.timestamps
    end

    add_index :weibo_users, :deleted_at
    add_index :weibo_users, :uid, unique: true
  end
end
