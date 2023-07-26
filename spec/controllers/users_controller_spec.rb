require 'rails_helper'

# spec/controllers/api/v1/users_controller_spec.rb

RSpec.describe Api::V1::UsersController, type: :controller do
    describe "POST #create" do
      context "with valid parameters for attendee" do
        let(:valid_params) { { user: { email: 'test@example.com', password: 'password', role: 'attendee' } } }
  
        it "creates a new user" do
          expect {
            post :create, params: valid_params
          }.to change(User, :count).by(1)
        end
  
        it "returns a success response" do
          post :create, params: valid_params
          expect(response).to have_http_status(:created)
        end
  
        it "assigns the correct role to the user" do
          post :create, params: valid_params
          created_user = User.last
          expect(created_user.role).to eq('attendee')
        end
  
        it "creates an attendee user" do
          post :create, params: valid_params
          created_user = User.last
          expect(created_user.attendee?).to be true
          expect(created_user.admin?).to be false
        end
      end

      context "with valid parameters for admin" do
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
  
        it "assigns the correct role to the user" do
          post :create, params: valid_params
          created_user = User.last
          expect(created_user.role).to eq('admin')
        end
  
        it "creates an admin user" do
          post :create, params: valid_params
          created_user = User.last
          expect(created_user.admin?).to be true
          expect(created_user.attendee?).to be false
        end
      end
  
      context "with invalid parameters" do
        let(:invalid_params) { { user: { email: 'invalid_email', password: '123', role: nil } } }
  
        it "does not create a new user" do
          expect {
            post :create, params: invalid_params
          }.to_not change(User, :count)
        end
  
        it "returns an error response" do
          post :create, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
  
  