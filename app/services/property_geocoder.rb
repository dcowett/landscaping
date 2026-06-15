# app/services/property_geocoder.rb
class PropertyGeocoder
  Result = Struct.new(
    :success?,
    :latitude,
    :longitude,
    :query_used,
    :matched_address,
    :error,
    keyword_init: true
  )

  def initialize(property, logger: Rails.logger, sleep_seconds: 0)
    @property = property
    @logger = logger
    @sleep_seconds = sleep_seconds
  end

  def call
    queries = candidate_queries

    if queries.empty?
      return Result.new(
        success?: false,
        error: "No usable address query could be built"
      )
    end

    queries.each do |query|
      safe_sleep_if_needed

      geocode_result = safe_search(query)
      next unless geocode_result

      coords = geocode_result.coordinates
      next unless coords.present? && coords.size == 2

      latitude, longitude = coords

      @property.latitude = latitude
      @property.longitude = longitude

      if @property.save(validate: false)
        log_info("Geocoded property #{@property.id} using query: #{query.inspect}")
        return Result.new(
          success?: true,
          latitude: latitude,
          longitude: longitude,
          query_used: query,
          matched_address: safe_result_address(geocode_result)
        )
      else
        return Result.new(
          success?: false,
          error: "Coordinates found but property could not be saved: #{@property.errors.full_messages.join(', ')}",
          query_used: query
        )
      end
    end

    Result.new(
      success?: false,
      error: "No geocoding match found",
      query_used: queries.first
    )
  end

  private

  def candidate_queries
    street = normalize_street(@property.situs_address)
    city   = normalize_city(@property.situs_postal_city)
    state  = normalize_state(property_state)
    zip    = normalize_zip(@property.situs_postal_zip)

    queries = []

    # Most specific
    queries << join_parts(street, city, state, zip, "USA")

    # Slightly less specific
    queries << join_parts(street, city, state, "USA")

    # Street + city only
    queries << join_parts(street, city, state)

    # Try expanded street suffixes (PL -> PLACE, ST -> STREET, etc.)
    expanded_street = expand_street_suffixes(street)
    if expanded_street.present? && expanded_street != street
      queries << join_parts(expanded_street, city, state, zip, "USA")
      queries << join_parts(expanded_street, city, state, "USA")
      queries << join_parts(expanded_street, city, state)
    end

    # Last fallback: city/state/zip centroid-like search
    queries << join_parts(city, state, zip, "USA")
    queries << join_parts(city, state, "USA")

    queries
      .map { |q| q.to_s.strip.gsub(/\s+/, " ") }
      .reject(&:blank?)
      .uniq
  end

  def safe_search(query)
    results = Geocoder.search(query)
    result = results.first

    if result.nil?
      log_info("No geocode result for query: #{query.inspect}")
      return nil
    end

    result
  rescue StandardError => e
    log_error("Geocoder error for property #{@property.id}, query #{query.inspect}: #{e.class} - #{e.message}")
    nil
  end

  def safe_result_address(result)
    result.address
  rescue StandardError
    nil
  end

  def normalize_street(value)
    cleaned = basic_clean(value)
    cleaned = cleaned.gsub(/\bAPT\b/i, "Apartment")
    cleaned = cleaned.gsub(/\bSTE\b/i, "Suite")
    cleaned.presence
  end

  def normalize_city(value)
    basic_clean(value)&.titleize
  end

  def normalize_state(value)
    cleaned = basic_clean(value)
    return nil if cleaned.blank?

    # If already 2-letter code, use uppercase
    return cleaned.upcase if cleaned.match?(/\A[a-z]{2}\z/i)

    state_map[cleaned.downcase] || cleaned.upcase
  end

  def normalize_zip(value)
    digits = value.to_s.gsub(/[^\d\-]/, "")
    digits.presence
  end

  def basic_clean(value)
    value.to_s
         .strip
         .gsub(/[^\p{Alnum}\s\-]/, " ")
         .gsub(/\s+/, " ")
         .presence
  end

  def expand_street_suffixes(street)
    return nil if street.blank?

    expanded = street.dup

    {
      /\bPL\b/i   => "Place",
      /\bST\b/i   => "Street",
      /\bAVE\b/i  => "Avenue",
      /\bRD\b/i   => "Road",
      /\bDR\b/i   => "Drive",
      /\bLN\b/i   => "Lane",
      /\bCT\b/i   => "Court",
      /\bBLVD\b/i => "Boulevard",
      /\bTER\b/i  => "Terrace",
      /\bCIR\b/i  => "Circle"
    }.each do |pattern, replacement|
      expanded = expanded.gsub(pattern, replacement)
    end

    expanded.gsub(/\s+/, " ").strip
  end

  def join_parts(*parts)
    parts.compact.reject(&:blank?).join(" ")
  end

  def property_state
    if @property.respond_to?(:situs_postal_state)
      @property.situs_postal_state
    else
      nil
    end
  end

  def state_map
    {
      "alabama" => "AL",
      "alaska" => "AK",
      "arizona" => "AZ",
      "arkansas" => "AR",
      "california" => "CA",
      "colorado" => "CO",
      "connecticut" => "CT",
      "delaware" => "DE",
      "florida" => "FL",
      "georgia" => "GA",
      "hawaii" => "HI",
      "idaho" => "ID",
      "illinois" => "IL",
      "indiana" => "IN",
      "iowa" => "IA",
      "kansas" => "KS",
      "kentucky" => "KY",
      "louisiana" => "LA",
      "maine" => "ME",
      "maryland" => "MD",
      "massachusetts" => "MA",
      "michigan" => "MI",
      "minnesota" => "MN",
      "mississippi" => "MS",
      "missouri" => "MO",
      "montana" => "MT",
      "nebraska" => "NE",
      "nevada" => "NV",
      "new hampshire" => "NH",
      "new jersey" => "NJ",
      "new mexico" => "NM",
      "new york" => "NY",
      "north carolina" => "NC",
      "north dakota" => "ND",
      "ohio" => "OH",
      "oklahoma" => "OK",
      "oregon" => "OR",
      "pennsylvania" => "PA",
      "rhode island" => "RI",
      "south carolina" => "SC",
      "south dakota" => "SD",
      "tennessee" => "TN",
      "texas" => "TX",
      "utah" => "UT",
      "vermont" => "VT",
      "virginia" => "VA",
      "washington" => "WA",
      "west virginia" => "WV",
      "wisconsin" => "WI",
      "wyoming" => "WY"
    }
  end

  def safe_sleep_if_needed
    sleep(@sleep_seconds) if @sleep_seconds.to_f > 0
  end

  def log_info(message)
    @logger&.info("[PropertyGeocoder] #{message}")
  end

  def log_error(message)
    @logger&.error("[PropertyGeocoder] #{message}")
  end
end
