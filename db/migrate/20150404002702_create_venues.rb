class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :yelp_id

      t.timestamps
    end
  end
end
