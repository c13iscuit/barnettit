class AddUpvotesToAnswers < ActiveRecord::Migration
  def up
    add_column :answers, :upvotes, :integer, :default => 0
  end

  def down
    remove_column :answers, :upvotes
  end
end
