
require 'rails_helper'

RSpec.describe "Testing the Users endpoint" do

  describe 'POST /signup' do
    context "with valid user data" do
      it 'create new user' do
        user_params = { name: 'John Down', email: 'john@exemple.com', password: 'password123' }
        post :create, params: { user: user_params }

        expect(response).to have_http_status(:created)
        expect(response.body).to include('User created successfully!')
        expect(User.count).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'return empty errors' do
        post :create, params: { user: { name: "", email: "", password: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include(
          "name can't be blank",
          "email can't be blank",
          "password can't be blank"
        )
      end

      it 'returns format errors' do
        post :create, params: { user: { name: "1231Ra", email: "People", password: "1234567" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include(
          "name must contain only letters",
          "email is invalid",
          "must be at least 8 characters long"
        )
      end

    end
  end



end
