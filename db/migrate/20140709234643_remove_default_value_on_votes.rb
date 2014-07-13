class RemoveDefaultValueOnVotes < ActiveRecord::Migration
  def change
    change_column_default(:votes, :value, nil)
  end
end
