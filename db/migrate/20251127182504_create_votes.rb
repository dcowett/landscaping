class CreateVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :votes do |t|
      t.integer :story_id

      t.timestamps
    end
  end
end
