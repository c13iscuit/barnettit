class AddUserIdToQuestionAnswer < ActiveRecord::Migration
  def up
    add_column :questions, :user_id, :integer, null: false
    add_column :answers, :user_id, :integer,  null: false
  end

  def down
    remove_column :questions, :user_id
    remove_column :answers, :user_id
  end
end
