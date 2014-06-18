class AddImageToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :image, :string
  end
end
