class AddPostedAtToWeiboUsers < ActiveRecord::Migration
  def change
    add_column :weibo_users, :posted_at, :datetime, after: :last_weibo_id

    Weibo::User.reset_column_information

    Weibo::User.all.each do|u|
      u.update(posted_at: u.checked_at)
    end
  end
end
