class AddStoryIdIndexToVotes < ActiveRecord::Migration[8.1]
  def change
    add_index :votes, :story_id
  end
end
