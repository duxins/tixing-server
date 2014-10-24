class AddUrlToServices < ActiveRecord::Migration
  def change
    add_column :services, :url, :string, after: :icon
  end
end
