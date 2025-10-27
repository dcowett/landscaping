class AddIndexToPropertiesSitusAddress < ActiveRecord::Migration[8.0]
  def change
    add_index :properties, :situs_address, unique: true
  end
end
