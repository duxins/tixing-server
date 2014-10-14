class CreateInstallations < ActiveRecord::Migration
  def change
    create_table :installations do |t|
      t.references :user, index: true
      t.references :service, index: true
      t.text :preferences

      t.timestamps
    end

    add_index :installations, [:user_id, :service_id], unique: true
  end
end
