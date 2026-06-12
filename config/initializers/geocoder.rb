Geocoder.configure(
  lookup: :nominatim,
  timeout: 5,

  # ✅ REQUIRED (this is the main fix)
  http_headers: {
    "User-Agent" => "landscaping-app (david@cowett.us)"
  }
)
