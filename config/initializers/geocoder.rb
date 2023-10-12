Geocoder.configure(
    lookup: :nominatim,
    http_headers: { "User-Agent" => "MyApp" },
    timeout: 5
)
  