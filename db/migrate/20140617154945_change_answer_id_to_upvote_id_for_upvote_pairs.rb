class ChangeAnswerIdToUpvoteIdForUpvotePairs < ActiveRecord::Migration
  def change
    remove_column :upvote_pairs, :answer_id
    add_column :upvote_pairs, :upvote_id, :integer, null: false
  end
end
