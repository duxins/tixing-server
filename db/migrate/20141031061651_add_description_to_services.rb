class AddDescriptionToServices < ActiveRecord::Migration
  def change
    add_column :services, :description, :string
  end
end
