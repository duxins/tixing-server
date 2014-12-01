class CreateJingdongPrices < ActiveRecord::Migration
  def change
    create_table :jingdong_prices do |t|
      t.references :product, index: true, limit: 8
      t.decimal :price, precision:8, scale: 1
      t.string :promotion
      t.timestamps
    end
  end
end
