class Videos < ActiveRecord::Migration
  def up
    create_table :videos do |t|
  	  t.string :title
  	  t.string :author
  	  t.string :host
  	  t.string :uri
  	  t.text :description
  	  t.timestamps
  	end
  end
  def down
    drop_table :videos
  end
end