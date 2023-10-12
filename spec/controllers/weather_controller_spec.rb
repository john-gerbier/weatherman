require 'rails_helper'

RSpec.describe WeatherController, type: :controller do

  describe 'GET /index' do
    it 'returns HTTP success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns HTTP success' do
      get :new, params: { address: 'Das, Cerdanya, Girona, Catalonia, Spain' }
      expect(response).to have_http_status(:success)
    end

    it 'fetches weather data for a valid address' do
      # Mock the Geocoder result for a valid address
      allow(Geocoder).to receive(:search).and_return([double('geocode', latitude: 123, longitude: 456, data: { 'address' => { 'postcode' => '12345' } })])

      # Mock the weather API response
      allow(controller).to receive(:get_weather_data).and_return({ 'main' => { 'temp' => 22.5 } })

      get :new, params: { address: 'Das, Cerdanya, Girona, Catalonia, Spain' }

      expect(assigns(:cached_result)).to eq(true)
      expect(assigns(:forecast)).to be_present
    end

    it 'handles errors when the weather API fails' do
        allow(Geocoder).to receive(:search).and_return([double('geocode', latitude: 123, longitude: 456, data: { 'address' => { 'postcode' => '12345' } })])
        allow(controller).to receive(:get_weather_data).and_raise(StandardError, 'Weather API failed')
      
        get :new, params: { address: 'Valid Address' }
      
        expect(assigns(:cached_result)).to eq(false) # Should be set to false
        expect(assigns(:forecast)).to be_nil
        expect(flash[:error]).to be_present
    end

    it 'handles errors when geocode result is not available' do
      allow(Geocoder).to receive(:search).and_return([]) # Simulate geocode result not found

      get :new, params: { address: 'Invalid Address' }

      expect(assigns(:cached_result)).to eq(false) # Should be set to false
      expect(assigns(:forecast)).to be_nil
      expect(flash[:error]).to be_present
    end

    it 'handles missing address parameter' do
      get :new

      expect(assigns(:cached_result)).to eq(false) # Should be set to false
      expect(assigns(:forecast)).to be_nil
      expect(flash[:error]).to be_present
    end
  end
end
