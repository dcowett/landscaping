class CreateStories < ActiveRecord::Migration[8.1]
  def change
    create_table :stories do |t|
      t.string :name
      t.string :link

      t.timestamps
    end
  end
end
