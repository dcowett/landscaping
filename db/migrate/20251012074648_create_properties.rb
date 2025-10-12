class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.integer :parid
      t.string :situs_address
      t.string :situs_postal_city
      t.string :situs_postal_zip
      t.string :land_use_code
      t.string :land_use_desc
      t.string :homestead_indicator
      t.string :tax_district
      t.date :last_sale_date
      t.string :last_sale_vori
      t.string :last_sale_qualified
      t.decimal :last_sale_price
      t.float :land_acreage
      t.integer :bldg1_year_built
      t.string :bldgs_sqft_living
      t.string :integer
      t.integer :bldgs_sqft_unroof
      t.string :swimming_pool
      t.string :community_dev_dist
      t.string :cra_name
      t.string :neighborhood_code
      t.string :neighborhood_name
      t.string :subdivision_code
      t.string :subdivision_name
      t.decimal :just_value
      t.decimal :county_assessed_value
      t.decimal :county_exempt_value
      t.decimal :county_taxable_value
      t.string :owner_name_line1
      t.string :owner_name_line2
      t.string :mailing_address_line1
      t.string :mailing_address_line2
      t.string :mailing_city
      t.string :mailing_state
      t.string :mailing_postal_code
      t.string :mailing_country

      t.timestamps
    end
  end
end
