class AddUserIdToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :userid, :integer
  end
end
