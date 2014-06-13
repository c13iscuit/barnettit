class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |table|
      table.string :username, null: false
    end
  end
end
