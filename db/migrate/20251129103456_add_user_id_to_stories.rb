class AddUserIdToStories < ActiveRecord::Migration[8.1]
  def change
    add_column :stories, :user_id, :integer
    add_index :stories, :user_id
  end
end
