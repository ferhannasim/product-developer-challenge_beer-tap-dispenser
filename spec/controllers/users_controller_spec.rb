require 'rails_helper'

# spec/controllers/api/v1/users_controller_spec.rb

RSpec.describe Api::V1::UsersController, type: :controller do
    describe "POST #create" do
      context "with valid parameters" do
        let(:valid_params) { { user: { email: 'test@example.com', password: 'password', role: 'admin' } } }
  
        it "creates a new user" do
          expect {
            post :create, params: valid_params
          }.to change(User, :count).by(1)
        end
  
        it "returns a success response" do
          post :create, params: valid_params
          expect(response).to have_http_status(:created)
        end
      end
  
      context "with invalid parameters" do
        let(:invalid_params) { { user: { email: 'invalid_email', password: '123', role: nil } } }
  
        it "returns an error response" do
          post :create, params: invalid_params
          byebug
          expect(response).to have_http_status(:unprocessable_entity)
        end
  
        it "returns error messages in the response" do
          post :create, params: invalid_params
          expect(JSON.parse(response.body)).to include('errors' => include("Email is invalid", "Password is too short", "Role is not included in the list"))
        end
      end
    end
  end
  