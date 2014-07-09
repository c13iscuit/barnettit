class ChangeVotesTable < ActiveRecord::Migration
  def change
    rename_column :votes, :count, :value
    rename_column :votes, :upvotable_id, :votable_id
    rename_column :votes, :upvotable_type, :votable_type
  end
end
