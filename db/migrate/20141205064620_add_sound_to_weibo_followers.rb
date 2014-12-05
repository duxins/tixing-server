class AddSoundToWeiboFollowers < ActiveRecord::Migration
  def change
    add_column :weibo_followers, :sound, :string, default: ''
  end
end
