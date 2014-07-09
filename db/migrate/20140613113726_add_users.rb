class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :uid
      t.string :provider

      t.timestamps
    end
  end
end
