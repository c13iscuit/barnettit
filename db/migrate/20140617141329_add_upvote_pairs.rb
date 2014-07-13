class AddUpvotePairs < ActiveRecord::Migration
  def change
    create_table :upvote_pairs do |t|
      t.integer :user_id, null: false
      t.integer :upvote_id, null: false
      t.integer :vote, null: false, default: 0
    end
  end
end
