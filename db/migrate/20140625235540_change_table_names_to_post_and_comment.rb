class ChangeTableNamesToPostAndComment < ActiveRecord::Migration
  def up
    rename_table(:questions, :posts)
    rename_column(:answers, :question_id, :post_id)
    rename_table(:answers, :comments)
  end

  def down
    rename_table(:posts, :questions)
    rename_table(:comments, :answers)
    rename_column(:answers, :post_id, :question_id)
  end
end
