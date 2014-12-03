class CreateShunfengProducts < ActiveRecord::Migration
  def change
    create_table :shunfeng_products, id:false do |t|
      t.column :id, 'bigint(20) PRIMARY KEY'
      t.integer :sku
      t.string :name
      t.string :image
      t.string :promotion
      t.decimal :price, precision:8, scale: 1
      t.integer :monitorings_count, default: 0
      t.timestamps
    end
  end
end
