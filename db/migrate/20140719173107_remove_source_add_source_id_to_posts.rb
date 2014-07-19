class RemoveSourceAddSourceIdToPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :source
    add_column :posts, :source_id, :integer
  end
end
