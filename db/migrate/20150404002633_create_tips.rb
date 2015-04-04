class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.string :name
      t.string :text
      t.integer :venue_id

      t.timestamps
    end
  end
end
