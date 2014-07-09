class RemoveUpvotePairs < ActiveRecord::Migration
  def up
    drop_table :upvote_pairs
  end

  def down
    create_table "upvote_pairs" do |t|
      t.integer "user_id", null: false
      t.integer "upvote_id", null: false
      t.integer "vote", default: 0, null: false
    end
  end
end
