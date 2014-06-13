class RemoveUserIdFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :user_id
  end

  def down
    add_column :questions, :user_id, :string, null: false
  end
end
