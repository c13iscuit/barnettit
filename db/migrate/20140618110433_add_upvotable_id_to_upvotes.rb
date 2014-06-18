class AddUpvotableIdToUpvotes < ActiveRecord::Migration
  def change
    add_column :upvotes, :upvotable_id, :integer, null: false
    add_column :upvotes, :upvotable_type, :string, null: false
  end
end
