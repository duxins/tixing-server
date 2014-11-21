class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks, options: 'CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci' do |t|
      t.references :user
      t.text :content
      t.text :memo

      t.timestamps
    end
  end
end
