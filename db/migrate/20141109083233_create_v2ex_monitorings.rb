class CreateV2exMonitorings < ActiveRecord::Migration
  def change
    create_table :v2ex_monitorings do |t|
      t.references :user, index: true
      t.string :keyword, index: true
      t.timestamps
    end
  end
end
