class AddReferenceIdReferenceTypeValueToLikes < ActiveRecord::Migration[8.1]
  def change
    add_column :likes, :reference_id, :integer
    add_column :likes, :reference_type, :string
    add_column :likes, :value, :integer, default: 0
  end
end
