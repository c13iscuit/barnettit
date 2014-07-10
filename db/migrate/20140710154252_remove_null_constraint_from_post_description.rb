class RemoveNullConstraintFromPostDescription < ActiveRecord::Migration
  def change
    change_column :posts, :description, :text, :null => true
  end
end
