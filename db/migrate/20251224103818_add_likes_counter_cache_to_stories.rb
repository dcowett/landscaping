class AddLikesCounterCacheToStories < ActiveRecord::Migration[8.1]
  def change
    add_column :stories, :likes_count, :integer, default: 0
    Story.find_each do |s|
      Story.reset_counters s.id, :likes
    end
  end
end
