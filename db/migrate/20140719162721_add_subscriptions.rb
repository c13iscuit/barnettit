class AddSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :source_id, null: false
      t.timestamps
    end

    create_table :sources do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
