class UserAccounts < ActiveRecord::Migration
  def up
    create_table :accounts do |t|
  	  t.string :username
  	  t.string :password
  	  t.boolean :is_super
  	  t.boolean :perm_articles
  	  t.boolean :perm_news
  	  t.boolean :perm_videos
  	  t.boolean :perm_links
  	  t.timestamps
  	end
  end
  def down
    drop_table :accounts
  end
end