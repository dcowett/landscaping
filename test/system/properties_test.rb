require "application_system_test_case"

class PropertiesTest < ApplicationSystemTestCase
  setup do
    @property = properties(:one)
  end

  test "visiting the index" do
    visit properties_url
    assert_selector "h1", text: "Properties"
  end

  test "should create property" do
    visit properties_url
    click_on "New property"

    fill_in "Bldg1 year built", with: @property.bldg1_year_built
    fill_in "Bldgs sqft living", with: @property.bldgs_sqft_living
    fill_in "Bldgs sqft unroof", with: @property.bldgs_sqft_unroof
    fill_in "Community dev dist", with: @property.community_dev_dist
    fill_in "County assessed value", with: @property.county_assessed_value
    fill_in "County exempt value", with: @property.county_exempt_value
    fill_in "County taxable value", with: @property.county_taxable_value
    fill_in "Cra name", with: @property.cra_name
    fill_in "Homestead indicator", with: @property.homestead_indicator
    fill_in "Integer", with: @property.integer
    fill_in "Just value", with: @property.just_value
    fill_in "Land acreage", with: @property.land_acreage
    fill_in "Land use code", with: @property.land_use_code
    fill_in "Land use desc", with: @property.land_use_desc
    fill_in "Last sale date", with: @property.last_sale_date
    fill_in "Last sale price", with: @property.last_sale_price
    fill_in "Last sale qualified", with: @property.last_sale_qualified
    fill_in "Last sale vori", with: @property.last_sale_vori
    fill_in "Mailing address line1", with: @property.mailing_address_line1
    fill_in "Mailing address line2", with: @property.mailing_address_line2
    fill_in "Mailing city", with: @property.mailing_city
    fill_in "Mailing country", with: @property.mailing_country
    fill_in "Mailing postal code", with: @property.mailing_postal_code
    fill_in "Mailing state", with: @property.mailing_state
    fill_in "Neighborhood code", with: @property.neighborhood_code
    fill_in "Neighborhood name", with: @property.neighborhood_name
    fill_in "Owner name line1", with: @property.owner_name_line1
    fill_in "Owner name line2", with: @property.owner_name_line2
    fill_in "Parid", with: @property.parid
    fill_in "Situs address", with: @property.situs_address
    fill_in "Situs postal city", with: @property.situs_postal_city
    fill_in "Situs postal zip", with: @property.situs_postal_zip
    fill_in "Subdivision code", with: @property.subdivision_code
    fill_in "Subdivision name", with: @property.subdivision_name
    fill_in "Swimming pool", with: @property.swimming_pool
    fill_in "Tax district", with: @property.tax_district
    click_on "Create Property"

    assert_text "Property was successfully created"
    click_on "Back"
  end

  test "should update Property" do
    visit property_url(@property)
    click_on "Edit this property", match: :first

    fill_in "Bldg1 year built", with: @property.bldg1_year_built
    fill_in "Bldgs sqft living", with: @property.bldgs_sqft_living
    fill_in "Bldgs sqft unroof", with: @property.bldgs_sqft_unroof
    fill_in "Community dev dist", with: @property.community_dev_dist
    fill_in "County assessed value", with: @property.county_assessed_value
    fill_in "County exempt value", with: @property.county_exempt_value
    fill_in "County taxable value", with: @property.county_taxable_value
    fill_in "Cra name", with: @property.cra_name
    fill_in "Homestead indicator", with: @property.homestead_indicator
    fill_in "Integer", with: @property.integer
    fill_in "Just value", with: @property.just_value
    fill_in "Land acreage", with: @property.land_acreage
    fill_in "Land use code", with: @property.land_use_code
    fill_in "Land use desc", with: @property.land_use_desc
    fill_in "Last sale date", with: @property.last_sale_date
    fill_in "Last sale price", with: @property.last_sale_price
    fill_in "Last sale qualified", with: @property.last_sale_qualified
    fill_in "Last sale vori", with: @property.last_sale_vori
    fill_in "Mailing address line1", with: @property.mailing_address_line1
    fill_in "Mailing address line2", with: @property.mailing_address_line2
    fill_in "Mailing city", with: @property.mailing_city
    fill_in "Mailing country", with: @property.mailing_country
    fill_in "Mailing postal code", with: @property.mailing_postal_code
    fill_in "Mailing state", with: @property.mailing_state
    fill_in "Neighborhood code", with: @property.neighborhood_code
    fill_in "Neighborhood name", with: @property.neighborhood_name
    fill_in "Owner name line1", with: @property.owner_name_line1
    fill_in "Owner name line2", with: @property.owner_name_line2
    fill_in "Parid", with: @property.parid
    fill_in "Situs address", with: @property.situs_address
    fill_in "Situs postal city", with: @property.situs_postal_city
    fill_in "Situs postal zip", with: @property.situs_postal_zip
    fill_in "Subdivision code", with: @property.subdivision_code
    fill_in "Subdivision name", with: @property.subdivision_name
    fill_in "Swimming pool", with: @property.swimming_pool
    fill_in "Tax district", with: @property.tax_district
    click_on "Update Property"

    assert_text "Property was successfully updated"
    click_on "Back"
  end

  test "should destroy Property" do
    visit property_url(@property)
    click_on "Destroy this property", match: :first

    assert_text "Property was successfully destroyed"
  end
end
