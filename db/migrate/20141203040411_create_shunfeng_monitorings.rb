class CreateShunfengMonitorings < ActiveRecord::Migration
  def change
    create_table :shunfeng_monitorings do |t|
      t.references :product, limit: 8
      t.references :user
      t.decimal :threshold
      t.boolean :disabled, default: false
      t.timestamps
    end

    add_index :shunfeng_monitorings, [:product_id, :user_id], unique: true
  end
end
