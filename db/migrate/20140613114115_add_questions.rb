class AddQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |table|
      table.string :title, null: false
      table.text :description, null:false
      table.integer :user_id, null: false

      table.timestamps
    end
  end
end
