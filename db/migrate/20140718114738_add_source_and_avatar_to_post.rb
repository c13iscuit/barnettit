class AddSourceAndAvatarToPost < ActiveRecord::Migration
  def change
    add_column :posts, :source, :string
    add_column :posts, :avatar, :string
  end
end
