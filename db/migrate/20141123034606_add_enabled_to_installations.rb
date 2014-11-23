class AddEnabledToInstallations < ActiveRecord::Migration
  def change
    add_column :installations, :enabled, :boolean, default: true
  end
end
