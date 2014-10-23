class AddSoundToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sound, :string, after: :auth_token
  end
end
