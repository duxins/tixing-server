class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :auth_token

      t.datetime :deleted_at
      t.timestamps
    end

    add_index :users, :auth_token
    add_index :users, :email, unique: true
    add_index :users, :deleted_at
  end
end
