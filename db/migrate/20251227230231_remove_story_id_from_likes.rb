class RemoveStoryIdFromLikes < ActiveRecord::Migration[8.1]
  def change
    remove_column :likes, :story_id, :integer
  end
end
