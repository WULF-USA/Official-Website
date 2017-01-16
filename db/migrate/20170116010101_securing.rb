class Securing < ActiveRecord::Migration
  def up
    remove_column :accounts, :password, :string
    add_column :accounts, :password_hash, :string
  end
  def down
    drop_table :accounts
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
end