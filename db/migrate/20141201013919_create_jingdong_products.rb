class CreateJingdongProducts < ActiveRecord::Migration
  def change
    create_table :jingdong_products, id: false do |t|
      t.column :id, 'bigint(20) PRIMARY KEY'
      t.string :name
      t.string :image
      t.decimal :price, precision:8, scale: 1
      t.integer :monitorings_count, default: 0
      t.timestamps
    end
  end
end
