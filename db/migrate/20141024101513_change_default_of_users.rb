class ChangeDefaultOfUsers < ActiveRecord::Migration
  def change
    change_column_default :users, :sound, 'tixing'
  end
end
