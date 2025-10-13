class RemoveUseridFromProperties < ActiveRecord::Migration[8.0]
  def change
    remove_column :properties, :userid, :integer
  end
end
