class AddUpvotes < ActiveRecord::Migration
  def change
    create_table :upvotes do |t|
      t.integer :user_id, null: false
      t.integer :upvotable_id, null: false
      t.string :upvotable_type, null: false
      t.integer :count, default: 0
    end
  end
end
