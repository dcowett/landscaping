class AddReferenceIdReferenceTypeValueToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :reference_id, :integer
    add_column :users, :reference_type, :string
    add_column :users, :value, :integer, default: 0
  end
end
