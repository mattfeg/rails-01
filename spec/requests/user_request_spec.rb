require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "GET '/users'" do
    let!(:user1) { create(:user, name: 'Matheus') }
    let!(:user2) { create(:user, name: 'Edimo') }
    let!(:user3) { create(:user, name: 'Pedim') }

    subject(:make_user_get_request) {
      get '/users', params: params
    }

    subject(:make_user_get_request_with_id) {
      get "/users/#{user1.id}"
    }

    context 'with /:id param' do
      let(:user_id) { user1.id }
      it 'returns a sucessful response' do
        make_user_get_request_with_id
        expect(response).to have_http_status(:ok)
      end
      it 'returns a user by id' do
        make_user_get_request_with_id
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq(user1.name)
      end
    end

    context 'without name filter' do
      let(:params) { {} }
      it 'returns a sucessful response' do
        make_user_get_request
        expect(response).to have_http_status(:ok)
      end
      it 'returns all created users' do
        make_user_get_request
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(3)
      end
    end

    context 'with name filter' do
      context 'when a user name matches the filter' do
        let(:params) { { name: 'Mat' } }
        it 'returns correct searched names' do
          make_user_get_request
          expect(response).to have_http_status(:ok)
          parsed_response = JSON.parse(response.body)
          expect(parsed_response.size).to eq(1)
          expect(parsed_response.first['name']).to eq('Matheus')
        end
      end

      context 'when a user name doesnt matches the filter' do
        let(:params) { { name: 'Daniel' } }
        it 'returns an empty list' do
          make_user_get_request
          expect(response).to have_http_status(:ok)
          parsed_response = JSON.parse(response.body)
          expect(parsed_response.size).to eq(0)
        end
      end
    end
  end

  describe "POST '/users'" do
    let(:valid_attributes) { attributes_for(:user) }
    let(:invalid_attributes) { { name: nil, cpf: nil, birth_date: nil } }

    subject(:make_user_post_request) {
      post '/users', params: params
    }

    context 'with valid attributes' do
      let(:params) { { user: valid_attributes } }
      it 'creates a new user' do
        expect {
          make_user_post_request
        }.to change(User, :count).by(1)
      end

      it 'returns a sucessful response' do
        make_user_post_request
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { user: invalid_attributes } }
      it 'does not create a new user' do
        expect {
          make_user_post_request
        }.not_to change(User, :count)
      end

      it 'returns an unprocessable entity response' do
        make_user_post_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH '/users'" do
    let!(:user) { create(:user) }

    subject(:make_user_patch_request) {
      patch "/users/#{user.id}", params: { user: new_attributes }
    }

    context 'with valid attributes' do
      let(:new_attributes) { attributes_for(:user) }
      it 'updates the user' do
        make_user_patch_request
        user.reload
        expect(user.name).to eq(new_attributes[:name])
      end

      it 'returns a sucessful response' do
        make_user_patch_request
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      let(:new_attributes) { { name: nil } }
      it 'does not update the user' do
        make_user_patch_request
        user.reload
        expect(user.name).not_to eq(nil)
      end

      it 'returns an unprocessable entity response' do
        make_user_patch_request
        user.reload
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE '/users'" do
    let!(:user) { create(:user) }

    subject(:make_user_delete_request) {
      delete "/users/#{user.id}"
    }

    it 'deletes the user' do
      expect {
        make_user_delete_request
      }.to change(User, :count).by(-1)
    end

    it 'returns a sucessful response' do
      make_user_delete_request
      expect(response).to have_http_status(:no_content)
    end

    it 'returns a unprocessable entity response' do
      allow(User).to receive(:find_by).and_return(user)
      allow(user).to receive(:destroy).and_return(false)

      make_user_delete_request
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
