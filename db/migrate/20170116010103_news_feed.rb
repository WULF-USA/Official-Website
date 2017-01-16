class NewsFeed < ActiveRecord::Migration
  def up
    create_table :feeds do |t|
  	  t.string :title
  	  t.string :author
  	  t.text :content
  	  t.timestamps
  	end
  end
  def down
    drop_table :feeds
  end
end