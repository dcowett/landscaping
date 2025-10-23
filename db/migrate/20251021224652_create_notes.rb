class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.string :code
      t.string :notes

      t.timestamps
    end
  end
end
