class AddUpvotePairs < ActiveRecord::Migration
  def change
    create_table :upvote_pairs do |t|
      t.integer :user_id, null: false
      t.integer :answer_id, null: false
    end
  end
end
