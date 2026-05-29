class AddPropertyToPins < ActiveRecord::Migration[8.1]
  def change
    add_reference :pins, :property, null: false, foreign_key: true
  end
end
