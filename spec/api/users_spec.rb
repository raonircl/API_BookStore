
require 'rails_helper'
require_relative '../../app/controllers/users_controller'

RSpec.describe "Testing the Users endpoint" do

  describe 'POST /signup' do
    context "with valid user data" do
      it 'create new user' do
        user_params = { name: 'John Down', email: 'john@exemple.com', password: 'password123' }
        post '/signup', params: { user: user_params }

        expect(response).to have_http_status(:created)
        expect(response.body).to include('User created successfully!')
        expect(User.count).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'return empty errors' do
        post '/signup', params: { user: { name: "", email: "", password: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include(
          "name can't be blank",
          "email can't be blank",
          "password can't be blank"
        )
      end

      it 'returns format errors' do
        post '/signup', params: { user: { name: "1231Ra", email: "People", password: "12345670" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include(
          "name must contain only letters",
          "email is invalid",
        )
      end

      it 'return invalid format password' do
        post '/signup', params: { user: { name: "Raoni", email: "raoni@exemple.com", password: "12315" }}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("must be at least 8 characters long")
      end

      it 'existing email' do
        post '/signup', params: { user: { name: "Raoni", email: "raoni@exemple.com", password: "1231500000" }}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'POST /login' do
    context 'with valid credentials' do
      it 'return a token' do
        user = FactoryBot.create(:user, email: 'john@example.com', password: 'password123')
        post '/login', params: { user: { email: 'john@example.com', password: 'password123' } }

        expect(response).to have_http_status(:success)
        expect(json_response['token']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'return unauthorized' do
        post '/login', params: { user: { email: 'invalid@example.com', password: 'invalid' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['errors']).to eq('Invalid email or password')
      end

      it 'return invalid empty' do
        post '/login', params: { user: { email: '', password: '' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['errors']).to include(
          "email can't be blank",
          "password can't be blank"
        )
      end
    end
  end
end
