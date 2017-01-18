class Resources < ActiveRecord::Migration
  def up
    create_table :resources do |t|
  	  t.string :title
  	  t.string :author
  	  t.string :url
  	  t.text :description
  	  t.timestamps
  	end
  end
  def down
    drop_table :resources
  end
end