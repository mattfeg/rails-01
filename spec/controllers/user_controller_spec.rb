require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    before do
      create_list(:user, 3)
    end

    it 'returns a sucessful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "assings all user to @users" do
      get :index
      expect(assigns(:users)).to match_array(User.all)
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }
    it "returns the resquested user" do
      get :show, params: { id: user.id }
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(user.id)
    end

    it "returns a sucessful response" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:user) }
    let(:invalid_attributes) { { name: nil, cpf: nil, birth_date: nil } }

    context 'with valid attributes' do
      it 'creates a new User' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "returns a sucessful response" do
        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new User' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it "returns a unprocessable entity response" do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { create(:user) }

    context 'with valid attributes' do
      let(:new_attributes) { attributes_for(:user) }
      it 'updates the user' do
        patch :update, params: { id: user.id, user: new_attributes }
        user.reload
        expect(user.name).to eq(new_attributes[:name])
      end

      it "returns a sucessull response" do
        patch :update, params: { id: user.id, user: new_attributes }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { name: nil } }
      it "does not update the user" do
        patch :update, params: { id: user.id, user: invalid_attributes }
        user.reload
        expect(user.name).not_to eq(nil)
      end

      it 'returns an unprocessable entity response' do
        patch :update, params: { id: user.id, user: invalid_attributes }
        user.reload
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }

    it "deletes the user" do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
    end

    it "returns a sucessful response" do
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:no_content)
    end

    it "returns a unprocessable entity response" do
      allow(User).to receive(:find).and_return(user)
      allow(user).to receive(:destroy).and_return(false)

      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
