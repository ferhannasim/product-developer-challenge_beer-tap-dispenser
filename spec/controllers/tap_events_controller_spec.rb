require 'rails_helper'

RSpec.describe TapEventsController, type: :request do

    let(:user) { create_user }
    let(:admin_user) { create_user(role: 'admin') }
    let(:dispenser) { Dispenser.create(flow_volume: 50) }
    let(:tap_event) { TapEvent.create(status: 'open', opened_at: Time.now ,user_id: user.id, dispenser_id: dispenser.id) }

    # Define a helper method to generate the authorization header with JWT token
    def auth_headers(user)
        token = JwtAuth.encode({ user_id: user.id })
        { 'Authorization' => "Bearer #{token}" }
    end

    # Define a helper method to create a new user in the test
    def create_user(role: 'attendee')
        User.create(email: 'user@example.com', password: 'password', role: role)
    end

  describe 'POST #create' do

    context 'when authenticated user' do

      it 'creates a new tap_event with status open' do
        # dispenser = Dispenser.create(flow_volume: 50)
        expect {
          post "/dispensers/#{dispenser.id}/tap_events", params: { dispenser_id: dispenser.id }, headers: auth_headers(user)
        }.to change(TapEvent, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized status' do
        # dispenser = Dispenser.create(flow_volume: 50)
        post "/dispensers/#{dispenser.id}/tap_events", params: { dispenser_id: dispenser.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #update' do

    context 'when authenticated user' do

      it 'updates the tap_event with status closed and calculates the price' do
        patch "/dispensers/#{dispenser.id}/tap_events/#{tap_event.id}", headers: auth_headers(user)

        tap_event.reload
        expect(tap_event.status).to eq('closed')
        expect(tap_event.closed_at).not_to be_nil
        expect(tap_event.price).not_to be_nil

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized status' do
        patch "/dispensers/#{dispenser.id}/tap_events/#{tap_event.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #usage_details' do

    context 'when authenticated user' do

    let(:tap_event) { TapEvent.create(status: 'closed', opened_at: Time.now, closed_at: Time.now - 10  ,user_id: user.id, dispenser_id: dispenser.id, price: 2.3) }
    let(:tap_event) { TapEvent.create(status: 'closed', opened_at: Time.now, closed_at: Time.now - 20  ,user_id: user.id, dispenser_id: dispenser.id, price: 3.4) }
      it 'returns the usage details' do
        get "/dispensers/#{dispenser.id}/tap_events/usage_details", headers: auth_headers(user)

        response_body =  JSON.parse(response.body)
        tap_events1 = TapEvent.where(dispenser_id: dispenser.id)
        expect(response).to have_http_status(:ok)
        expect(response_body['total_cost']).to eq(tap_events1.sum(&:price))
        expect(response_body['Dispenser_used']).to eq(tap_events1.count)
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized status' do
        get "/dispensers/#{dispenser.id}/tap_events/usage_details"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
