class AddAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id, null: false
    end
  end
end
