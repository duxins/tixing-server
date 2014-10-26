class AddTimezoneToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :timezone, :integer, default: 8
    add_column :users,   :silent_at_night, :boolean, default: false, after: :sound
  end
end
