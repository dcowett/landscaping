require "test_helper"

class OzoneControllerTest < ActionDispatch::IntegrationTest


  # ─── Helpers ────────────────────────────────────────────────────────────────

  def mock_aqi_response(aqi, category = "Good", area = "Tampa")
    [
      {
        "AQI"           => aqi,
        "Category"      => { "Name" => category },
        "ReportingArea" => area
      }
    ].to_json
  end

  def stub_api(response_body)
    stub_request(:get, /airnowapi\.org/)
      .to_return(status: 200, body: response_body, headers: { "Content-Type" => "application/json" })
    yield
  end

  # ─── Index ──────────────────────────────────────────────────────────────────

  test "index returns success" do
    stub_api(mock_aqi_response(42, "Good")) do
      get ozone_index_url
      assert_response :success
    end
  end

  test "index handles empty API response gracefully" do
    stub_api("[]") do
      get ozone_index_url
      assert_response :success
    end
  end

  test "index uses todays date in the API url" do
    expected_date = Date.today.strftime("%Y-%m-%d")
    stub_api(mock_aqi_response(42, "Good")) do
      get ozone_index_url
      assert_response :success
      # date is baked into the url — confirm no hardcoded date
      assert_includes @controller.instance_variable_get(:@url), expected_date
    end
  end

  # ─── Zipcode ────────────────────────────────────────────────────────────────

  test "zipcode returns success with valid zip" do
    stub_api(mock_aqi_response(55, "Moderate")) do
      post zipcode_url, params: { zipcode: "33607" }
      assert_response :success
    end
  end

  test "zipcode uses submitted zip in url" do
    stub_api(mock_aqi_response(55, "Moderate")) do
      post zipcode_url, params: { zipcode: "90210" }
      assert_includes @controller.instance_variable_get(:@url), "90210"
    end
  end

  test "zipcode falls back to message when blank zip submitted" do
    stub_api("[]") do
      post zipcode_url, params: { zipcode: "" }
      assert_response :success
      assert_equal "Hey, you did not enter anything",
                   @controller.instance_variable_get(:@zip_query)
    end
  end

  test "zipcode handles empty API response gracefully" do
    stub_api("[]") do
      post zipcode_url, params: { zipcode: "99999" }
      assert_response :success
      assert_equal "Error", @controller.instance_variable_get(:@final_output)
      assert_equal "bg-silver", @controller.instance_variable_get(:@api_color)
    end
  end

  test "zipcode uses todays date in the API url" do
    expected_date = Date.today.strftime("%Y-%m-%d")
    stub_api(mock_aqi_response(42, "Good")) do
      post zipcode_url, params: { zipcode: "33607" }
      assert_includes @controller.instance_variable_get(:@url), expected_date
    end
  end

  # ─── AQI color brackets ─────────────────────────────────────────────────────

  {
    "bg-green"  => [25,  "Good",                "Air quality is satisfactory"],
    "bg-yellow" => [75,  "Moderate",            "Air quality is acceptable"],
    "bg-orange" => [125, "Unhealthy for Some",  "Members of sensitive groups"],
    "bg-red"    => [175, "Unhealthy",           "Some members of the general public"],
    "bg-purple" => [225, "Very Unhealthy",      "Health alert"],
    "bg-maroon" => [375, "Hazardous",           "Health warning of emergency conditions"],
  }.each do |expected_color, (aqi, category, description_fragment)|
    test "AQI #{aqi} sets color #{expected_color}" do
      stub_api(mock_aqi_response(aqi, category)) do
        get ozone_index_url
        assert_equal expected_color,
                     @controller.instance_variable_get(:@api_color)
      end
    end

    test "AQI #{aqi} sets correct description" do
      stub_api(mock_aqi_response(aqi, category)) do
        get ozone_index_url
        assert_includes @controller.instance_variable_get(:@api_description),
                        description_fragment
      end
    end
  end

  # ─── AQI bracket boundary conditions ───────────────────────────────────────

  test "AQI exactly 50 sets bg-green" do
    stub_api(mock_aqi_response(50, "Good")) do
      get ozone_index_url
      assert_equal "bg-green", @controller.instance_variable_get(:@api_color)
    end
  end

  test "AQI exactly 51 sets bg-yellow" do
    stub_api(mock_aqi_response(51, "Moderate")) do
      get ozone_index_url
      assert_equal "bg-yellow", @controller.instance_variable_get(:@api_color)
    end
  end

  test "AQI exactly 100 sets bg-yellow" do
    stub_api(mock_aqi_response(100, "Moderate")) do
      get ozone_index_url
      assert_equal "bg-yellow", @controller.instance_variable_get(:@api_color)
    end
  end

  test "AQI exactly 101 sets bg-orange" do
    stub_api(mock_aqi_response(101, "Unhealthy for Some")) do
      get ozone_index_url
      assert_equal "bg-orange", @controller.instance_variable_get(:@api_color)
    end
  end

  test "AQI exactly 500 sets bg-maroon" do
    stub_api(mock_aqi_response(500, "Hazardous")) do
      get ozone_index_url
      assert_equal "bg-maroon", @controller.instance_variable_get(:@api_color)
    end
  end

  test "error state sets bg-silver with no description" do
    stub_api("[]") do
      get ozone_index_url
      assert_equal "bg-silver", @controller.instance_variable_get(:@api_color)
      assert_nil @controller.instance_variable_get(:@api_description)
    end
  end

  # ─── Parsed API data assignment ─────────────────────────────────────────────

  test "index assigns final_output from API response" do
    stub_api(mock_aqi_response(42, "Good", "St. Pete")) do
      get ozone_index_url
      assert_equal 42,        @controller.instance_variable_get(:@final_output)
      assert_equal "Good",    @controller.instance_variable_get(:@final_category)
      assert_equal "St. Pete", @controller.instance_variable_get(:@final_area)
    end
  end

end
