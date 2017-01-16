class Cleanup < ActiveRecord::Migration
  def up
    remove_column :accounts, :perm_articles, :boolean
    remove_column :accounts, :perm_news, :boolean
    remove_column :accounts, :perm_videos, :boolean
    remove_column :accounts, :perm_links, :boolean
  end
  def down
    add_column :accounts, :perm_articles, :boolean
    add_column :accounts, :perm_news, :boolean
    add_column :accounts, :perm_videos, :boolean
    add_column :accounts, :perm_links, :boolean
  end
end