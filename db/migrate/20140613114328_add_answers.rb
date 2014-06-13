class AddAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |table|
      table.string :title, null: false
      table.text :description, null: false
      table.integer :question_id, null: false

      table.timestamps
    end
  end
end
