class CreateForumPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :forum_posts do |table|
      table.column :name, :string, :limit => 50, :null => false
      table.column :subject, :string, :limit => 255, :null => false
      table.column :body, :text
      
      table.column :root_id, :integer, :limit => 8, :null => false, :default => 0
      table.column :parent_id, :integer, :limit => 8, :null => false, :default => 0
      table.column :depth, :integer, :null => false, :default => 0
      
      table.timestamps
    end
  end
  def self.down
    drop_table :forum_posts
  end
end
