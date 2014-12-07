class AddRegUserAgentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reg_user_agent, :string
    add_column :users, :reg_ip, :string
  end
end
