class RemoveAnswerIdFromUpvotes < ActiveRecord::Migration
  def change
    remove_column :upvotes, :answer_id
  end
end
