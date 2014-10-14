class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :token
      t.references :user, index: true

      t.timestamps
    end
  end
end
