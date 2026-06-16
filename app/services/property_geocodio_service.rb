# app/services/property_geocodio_service.rb

require "geocodio/gem"

class PropertyGeocodioService
  Result = Struct.new(
    :success,
    :latitude,
    :longitude,
    :formatted_address,
    :accuracy,
    :accuracy_type,
    :error,
    keyword_init: true
  ) do
    def success? = success
  end

  def initialize(property, logger: Rails.logger)
    @property = property
    @logger = logger
    @client = Geocodio::Gem.new(api_key)
  end

  def call
    address = geocoding_address
    return failure("No usable address") if address.blank?

    response = @client.geocode([address])
    results = response["results"] || []
    best = results.first

    return failure("No geocoding match found") if best.nil?

    location = best["location"] || {}
    lat = location["lat"]
    lng = location["lng"]

    return failure("Coordinates missing in Geocodio response") if lat.nil? || lng.nil?

    @property.latitude = lat
    @property.longitude = lng

    if @property.save(validate: false)
      success(
        latitude: lat,
        longitude: lng,
        formatted_address: best["formatted_address"],
        accuracy: best["accuracy"],
        accuracy_type: best["accuracy_type"]
      )
    else
      failure("Property could not be saved: #{@property.errors.full_messages.join(', ')}")
    end
  rescue StandardError => e
    @logger.error("[PropertyGeocodioService] #{e.class}: #{e.message}\n#{e.backtrace.first(5).join("\n")}")
    failure("#{e.class}: #{e.message}")
  end

  private

  def geocoding_address
    street = normalize(@property.situs_address)
    city   = normalize(@property.situs_postal_city)
    state  = normalize(property_state)
    zip    = normalize(@property.situs_postal_zip)

    return nil if street.blank?

    city_state_zip = [city, [state, zip].compact.join(" ")].compact_blank.join(", ")
    [street, city_state_zip.presence].compact.join(", ")
  end

  def property_state
    @property.respond_to?(:situs_postal_state) ? @property.situs_postal_state : nil
  end

  def normalize(value)
    cleaned = value.to_s.strip.gsub(/\s+/, " ")
    cleaned.presence
  end

  def api_key
    ENV["GEOCODIO_API_KEY"].presence ||
      Rails.application.credentials.geocodio_api_key
  end

  def success(latitude:, longitude:, formatted_address:, accuracy:, accuracy_type:)
    @logger.info("[PropertyGeocodioService] Geocoded property #{@property.id}")
    Result.new(
      success: true,
      latitude: latitude,
      longitude: longitude,
      formatted_address: formatted_address,
      accuracy: accuracy,
      accuracy_type: accuracy_type
    )
  end

  def failure(message)
    @logger.warn("[PropertyGeocodioService] #{message} for property #{@property&.id}")
    Result.new(success: false, error: message)
  end
end
