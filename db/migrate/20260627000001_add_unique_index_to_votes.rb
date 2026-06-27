class AddUniqueIndexToVotes < ActiveRecord::Migration[8.1]
  def change
    add_index :votes, [:story_id, :user_id], unique: true
  end
end
