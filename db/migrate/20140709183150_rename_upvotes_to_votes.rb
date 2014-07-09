class RenameUpvotesToVotes < ActiveRecord::Migration
  def up
    rename_table :upvotes, :votes
  end

  def down
    rename_table :votes, :upvotes
  end
end
