class AddDescriptionToStories < ActiveRecord::Migration[8.1]
  def change
    add_column :stories, :description, :text
  end
end
