# spec/requests/dispensers_controller_spec.rb

require 'rails_helper'

RSpec.describe DispensersController, type: :request do
  let(:user) { create_user }
  let(:admin_user) { create_user(role: 'admin') }

  # Define a helper method to generate the authorization header with JWT token
  def auth_headers(user)
    token = JwtAuth.encode({ user_id: user.id })
    { 'Authorization' => "Bearer #{token}" }
  end

  # Define a helper method to create a new user in the test
  def create_user(role: 'attendee')
    User.create(email: 'user@example.com', password: 'password', role: role)
  end

  describe 'GET /dispensers' do
    it 'returns a list of dispensers' do
      # Create test data for dispensers directly in the test
      dispenser1 = Dispenser.create(flow_volume: 50)
      dispenser2 = Dispenser.create(flow_volume: 60)

      get '/dispensers', headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      response_body =  JSON.parse(response.body)
      
      expect(response_body.size).to eq(Dispenser.count)
    end
  end

  describe 'GET /dispensers/:id' do
    it 'returns a specific dispenser' do
      dispenser = Dispenser.create(flow_volume: 70)

      get "/dispensers/#{dispenser.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      response_body =  JSON.parse(response.body)
      expect(response_body['flow_volume']).to eq(70)
    end
  end

  describe 'POST /dispensers' do
    context 'when the user is an admin' do
      it 'creates a new dispenser' do
        dispenser_params = { dispenser: { flow_volume: 80 } }

        expect {
          post '/dispensers', params: dispenser_params, headers: auth_headers(admin_user)
        }.to change(Dispenser, :count).by(1)

        expect(response).to have_http_status(:created)
        response_body =  JSON.parse(response.body)
        expect(response_body['flow_volume']).to eq(80)
      end
    end

    context 'when the user is not an admin' do
      it 'does not create a new dispenser' do
        dispenser_params = { dispenser: { flow_volume: 80 } }

        expect {
          post '/dispensers', params: dispenser_params, headers: auth_headers(user)
        }.not_to change(Dispenser, :count)

        response_body =  JSON.parse(response.body)
        expect(response_body['message']).to eq('You are not authorized. Only for Admin')
      end
    end
  end

  describe 'PUT /dispensers/:id' do
    it 'updates an existing dispenser' do
      dispenser = Dispenser.create(flow_volume: 90)
      updated_params = { dispenser: { flow_volume: 100 } }

      put "/dispensers/#{dispenser.id}", params: updated_params, headers: auth_headers(admin_user)
      dispenser.reload

      expect(response).to have_http_status(:ok)
      expect(dispenser.flow_volume).to eq(100)
    end
  end

  describe 'GET /dispensers/usage_details' do
    it 'returns usage details for all dispensers' do
        # Create test data for tap_events directly in the test
      dispenser1 = Dispenser.create(flow_volume: 50)
      dispenser2 = Dispenser.create(flow_volume: 60)

      Dispenser.first.tap_events.create( price: 10, opened_at: Time.now - 2.hours, closed_at: Time.now, user_id: user.id)
      Dispenser.last.tap_events.create( price: 15, opened_at: Time.now - 1.hours, closed_at: Time.now, user_id: user.id)

      get '/dispensers/usage_details', headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      response_body =  JSON.parse(response.body)

      expect(response_body['total_cost'].to_f).to eq(25.0)
      expect(response_body['dispenser_used']).to eq(Dispenser.count)
    end
  end
end
