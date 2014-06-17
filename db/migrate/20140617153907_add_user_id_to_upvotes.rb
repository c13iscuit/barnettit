class AddUserIdToUpvotes < ActiveRecord::Migration
  def change
    add_column :upvotes, :user_id, :integer, null: false
  end
end
