class UpvotesToOwnTable < ActiveRecord::Migration
  def change
    remove_column :answers, :upvotes
    create_table :upvotes do |t|
      t.integer :answer_id, null: false
      t.integer :count, :default => 0
    end
  end
end
