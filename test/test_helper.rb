ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"  # add this line

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
    include Devise::Test::IntegrationHelpers

    # Properties geocode themselves via an after_commit callback
    # (PropertyGeocodioService) any time one is created or updated.
    # Stub the Geocodio API by default so tests that merely save a
    # Property don't have to know about geocoding, while still letting
    # individual tests override this stub for specific behavior.
    setup do
      stub_request(:get, /api\.geocod\.io\/v2\/geocode/).to_return(
        status: 200,
        body: {
          results: [
            {
              formatted_address: "123 Test St, Tampa, FL 33607",
              location: { lat: 27.9506, lng: -82.4572 },
              accuracy: 1,
              accuracy_type: "rooftop"
            }
          ]
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
    end
  end
end
