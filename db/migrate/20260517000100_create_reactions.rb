# db/migrate/20260517000100_create_reactions.rb
class CreateReactions < ActiveRecord::Migration[7.1]
  def change
    create_table :reactions do |t|
      t.references :story, null: false, foreign_key: true
      t.references :user,  null: false, foreign_key: true
      t.string :emoji, null: false

      t.timestamps
    end

    add_index :reactions, [:story_id, :user_id, :emoji], unique: true
  end
end
