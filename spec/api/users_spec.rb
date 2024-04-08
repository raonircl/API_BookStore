require 'rails_helper'
require_relative '../../app/controllers/users_controller'

RSpec.describe "Users API Endpoint" do
  describe 'POST /signup' do
    context "with valid user data" do
      it 'creates a new user' do
        expect { create_user }.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(json_response['message']).to eq('User created successfully!')
      end
    end

    context 'with invalid parameters' do
      it 'returns name, email empty errors' do
        post_invalid_signup_request(name: "", email: "", password: "10203040")
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Name can't be blank", "Email can't be blank", "Email is invalid")
      end

      it 'returns password empty error' do
        post_invalid_signup_request(name: "Raoni teste", email: "teste@exemple.com", password: "")
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Password must be at least 8 characters long")
      end

      it 'returns invalid format name, email' do
        post_invalid_signup_request(name: "1231Ra", email: "People", password: "12345670")
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Name is invalid", "Email is invalid")
      end

      it 'returns invalid format password' do
        post_invalid_signup_request(name: "Raoni", email: "raoni@exemple.com", password: "12315")
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Password must be at least 8 characters long")
      end

      it 'returns existing email error' do
        FactoryBot.create(:user, email: "raoni@exemple4.com")
        post_invalid_signup_request(name: "Raoni", email: "raoni@exemple4.com", password: "1231500000")
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'POST /login' do
    context 'with valid credentials' do
      it 'returns a token with valid credentials' do
        email = 'raoni@example4.com'
        password = '12322200'
        user = User.create(email: email, password: password)

        post '/login', params: { user: { email: email, password: password } }

        puts response.body

        expect(response).to have_http_status(:success)
        expect(json_response['token']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized with invalid credentials' do
        post '/login', params: { user: { email: 'invalid@example.com', password: 'invalid000' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['errors']).to eq('Invalid email or password')
      end

      it 'returns unauthorized with empty credentials' do
        post '/login', params: { user: { email: '', password: '' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['errors']).to include(
          "Invalid email or password"
        )
      end
    end
  end

  private

  def create_user
    user_params = FactoryBot.attributes_for(:user)
    post '/signup', params: { user: user_params }
    User.last
  end

  def post_invalid_signup_request(name:, email:, password:)
    post '/signup', params: { user: { name: name, email: email, password: password } }
  end

  def post_login_request(email, password)
    post '/login'
  end
end
