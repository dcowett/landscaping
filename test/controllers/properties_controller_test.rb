require "test_helper"

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @property = properties(:one)
  end

  test "should get index" do
    get properties_url
    assert_response :success
  end

  test "should get new" do
    get new_property_url
    assert_response :success
  end

  test "should create property" do
    assert_difference("Property.count") do
      post properties_url, params: { property: { bldg1_year_built: @property.bldg1_year_built, bldgs_sqft_living: @property.bldgs_sqft_living, bldgs_sqft_unroof: @property.bldgs_sqft_unroof, community_dev_dist: @property.community_dev_dist, county_assessed_value: @property.county_assessed_value, county_exempt_value: @property.county_exempt_value, county_taxable_value: @property.county_taxable_value, cra_name: @property.cra_name, homestead_indicator: @property.homestead_indicator, integer: @property.integer, just_value: @property.just_value, land_acreage: @property.land_acreage, land_use_code: @property.land_use_code, land_use_desc: @property.land_use_desc, last_sale_date: @property.last_sale_date, last_sale_price: @property.last_sale_price, last_sale_qualified: @property.last_sale_qualified, last_sale_vori: @property.last_sale_vori, mailing_address_line1: @property.mailing_address_line1, mailing_address_line2: @property.mailing_address_line2, mailing_city: @property.mailing_city, mailing_country: @property.mailing_country, mailing_postal_code: @property.mailing_postal_code, mailing_state: @property.mailing_state, neighborhood_code: @property.neighborhood_code, neighborhood_name: @property.neighborhood_name, owner_name_line1: @property.owner_name_line1, owner_name_line2: @property.owner_name_line2, parid: @property.parid, situs_address: @property.situs_address, situs_postal_city: @property.situs_postal_city, situs_postal_zip: @property.situs_postal_zip, subdivision_code: @property.subdivision_code, subdivision_name: @property.subdivision_name, swimming_pool: @property.swimming_pool, tax_district: @property.tax_district } }
    end

    assert_redirected_to property_url(Property.last)
  end

  test "should show property" do
    get property_url(@property)
    assert_response :success
  end

  test "should get edit" do
    get edit_property_url(@property)
    assert_response :success
  end

  test "should update property" do
    patch property_url(@property), params: { property: { bldg1_year_built: @property.bldg1_year_built, bldgs_sqft_living: @property.bldgs_sqft_living, bldgs_sqft_unroof: @property.bldgs_sqft_unroof, community_dev_dist: @property.community_dev_dist, county_assessed_value: @property.county_assessed_value, county_exempt_value: @property.county_exempt_value, county_taxable_value: @property.county_taxable_value, cra_name: @property.cra_name, homestead_indicator: @property.homestead_indicator, integer: @property.integer, just_value: @property.just_value, land_acreage: @property.land_acreage, land_use_code: @property.land_use_code, land_use_desc: @property.land_use_desc, last_sale_date: @property.last_sale_date, last_sale_price: @property.last_sale_price, last_sale_qualified: @property.last_sale_qualified, last_sale_vori: @property.last_sale_vori, mailing_address_line1: @property.mailing_address_line1, mailing_address_line2: @property.mailing_address_line2, mailing_city: @property.mailing_city, mailing_country: @property.mailing_country, mailing_postal_code: @property.mailing_postal_code, mailing_state: @property.mailing_state, neighborhood_code: @property.neighborhood_code, neighborhood_name: @property.neighborhood_name, owner_name_line1: @property.owner_name_line1, owner_name_line2: @property.owner_name_line2, parid: @property.parid, situs_address: @property.situs_address, situs_postal_city: @property.situs_postal_city, situs_postal_zip: @property.situs_postal_zip, subdivision_code: @property.subdivision_code, subdivision_name: @property.subdivision_name, swimming_pool: @property.swimming_pool, tax_district: @property.tax_district } }
    assert_redirected_to property_url(@property)
  end

  test "should destroy property" do
    assert_difference("Property.count", -1) do
      delete property_url(@property)
    end

    assert_redirected_to properties_url
  end
end
