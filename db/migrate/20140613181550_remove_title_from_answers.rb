class RemoveTitleFromAnswers < ActiveRecord::Migration
  def up
    remove_column :answers, :title
  end

  def down
    add_column :answers, :title, null: false
  end
end
