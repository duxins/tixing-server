class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :users, :email, :name
  end
end
