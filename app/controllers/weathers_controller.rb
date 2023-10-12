class WeathersController < ApplicationController
  include HTTParty
  include Geocoder::Model

  def index
  end

  def new
    @cached_result = true # true by default

    begin
      geocode = Geocoder.search(address_params).first

      if geocode
        zip_code = geocode.data["address"]["postcode"] || geocode.data["place_id"]
  
        @forecast = Rails.cache.fetch("forecast_#{zip_code}", expires_in: 30.minutes) do
          get_weather_data(geocode.latitude, geocode.longitude)['main'].deep_symbolize_keys
        end
      else
        @cached_result = false # cached_result to false if geocode is not found
        flash[:error] = I18n.t(:geocode_location)
      end

    rescue StandardError => e
      @cached_result = false # cached_result to false when an error occurs
      flash[:error] = "#{I18n.t(:error)} #{e.message}"
      @forecast = nil
    end
  end

  private

  def address_params
    params.require(:address)
  end

  def get_weather_data(lat, lon)
    @cached_result = false # cached_result to false if geocode is not found

    JSON.parse(HTTParty.get(WEATHER_API, weather_query(lat, lon)).body)
  end

  def weather_query(lat, lon)
    {
      query: { 
        lat: lat, lon: lon, appid: Rails.application.credentials.openweather_api_key, units: 'metric' 
      } 
    }
  end
end
