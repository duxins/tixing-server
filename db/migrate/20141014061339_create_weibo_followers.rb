class CreateWeiboFollowers < ActiveRecord::Migration
  def change
    create_table :weibo_followers do |t|
      t.integer :uid, limit:8, null: false

      t.references :user, index: true
      t.string :keyword, limit: 1000
      t.timestamps
    end

    add_index :weibo_followers, :uid
  end
end
