class CreateSounds < ActiveRecord::Migration
  def change
    create_table :sounds do |t|
      t.string :name, index: true
      t.string :label
      t.string :package, default: ''
    end
  end
end
