class AddScoreToPostsAndComments < ActiveRecord::Migration
  def change
    add_column :posts, :score, :integer, default: 0
    add_column :comments, :score, :integer, default: 0
  end
end
