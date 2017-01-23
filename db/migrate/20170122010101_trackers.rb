class Trackers < ActiveRecord::Migration
  def up
    create_table :trackers do |t|
  	  t.string :url
  	  t.integer :visits
  	end
  end
  def down
    drop_table :trackers
  end
end