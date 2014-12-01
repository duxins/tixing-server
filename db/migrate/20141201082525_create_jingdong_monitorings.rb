class CreateJingdongMonitorings < ActiveRecord::Migration
  def change
    create_table :jingdong_monitorings do |t|
      t.references :product, limit: 8
      t.references :user
      t.decimal :price, precision:8, scale: 1
      t.decimal :threshold
      t.boolean :disabled, default: false
      t.timestamps
    end

    add_index :jingdong_monitorings, [:product_id, :user_id], unique: true

  end
end
