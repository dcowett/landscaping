class AddCounterCacheToStories < ActiveRecord::Migration[8.1]
  def change
    add_column :stories, :votes_count, :integer, default: 0
    Story.find_each do |s|
      Story.reset_counters s.id, :votes
    end
  end
end
