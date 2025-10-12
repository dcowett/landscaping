class RemoveBldgsSqftLivingFromProperties < ActiveRecord::Migration[8.0]
  def change
    remove_column :properties, :bldgs_sqft_living, :string
  end
end
