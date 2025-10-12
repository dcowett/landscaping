class AddBldgsSqftLivingToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :bldgs_sqft_living, :integer
  end
end
