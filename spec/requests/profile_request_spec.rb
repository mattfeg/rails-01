require 'rails_helper'

RSpec.describe ProfilesController, type: :request do
  describe "GET '/profiles'" do
    let!(:user1) { create(:user, name: 'Matheus').tap { |user| user.create_profile(is_active: true) } }
    let!(:user2) { create(:user, name: 'Edimo').tap { |user| user.create_profile(is_active: true) } }
    let!(:user3) { create(:user, name: 'Pedim').tap { |user| user.create_profile(is_active: true) } }

    context "without /:id param" do
      subject(:make_profile_get_request) {
        get "/profiles"
      }

      it 'returns a sucessful response' do
        make_profile_get_request
        expect(response).to have_http_status(:ok)
      end

      it 'returns all created profiles' do
        make_profile_get_request
        expect(response.parsed_body.size).to eq(3)
      end
    end
    context "with /:id param" do
      subject(:make_profile_get_request_with_id) {
        get "/profiles/#{user3.profile.id}"
      }
      it 'returns a sucessful response' do
        make_profile_get_request_with_id
        expect(response).to have_http_status(:ok)
      end
      it 'returns a profile by id for a correct user' do
        make_profile_get_request_with_id
        expect(response.parsed_body['id']).to eq(user3.profile.id)
      end
    end
  end
  describe "POST '/users'" do
    let(:valid_attributes) { attributes_for(:user) }
    let(:invalid_attributes) { { name: "Guy", cpf: "123", birthdate: "01/01/01",
    profile_attributes: { is_active: nil } } }
    subject(:make_profile_post_request) {
      post '/users', params: params
    }
    context 'with valid attributes' do
      let(:params) { { user: valid_attributes } }
      it 'creates a new profile' do
        expect { make_profile_post_request }.to change(Profile, :count).by(1)
      end
      it 'returns a sucessful response' do
        make_profile_post_request
        expect(response).to have_http_status(:created)
      end
    end
    context "with invalid attributes" do
      let(:params) { { user: invalid_attributes } }
      it 'does not create a new profile' do
        expect {
          make_profile_post_request
        }.not_to change(Profile, :count)
      end
      it 'returns an unprocessable entity response' do
        make_profile_post_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe "PATCH '/profiles'" do
    let!(:user) { create(:user).tap { |user| user.create_profile(is_active: true) } }
    subject(:make_profile_patch_request) {
      patch "/profiles/#{user.profile.id}",
      params: { profile: new_attributes }
    }
    context "with valid attributes" do
      let(:new_attributes) { attributes_for(:profile) }
      it 'updates the profile' do
        make_profile_patch_request
        user.reload
        expect(user.profile.is_active).to eq(new_attributes[:is_active])
      end
      it 'returns a sucessful response' do
        make_profile_patch_request
        expect(response).to have_http_status(:ok)
      end
    end
    context "with invalid attributes" do
      let(:new_attributes) { { is_active: "string" } }
      it 'does not update the profile' do
        expect {
          make_profile_patch_request
        }.not_to change(Profile, :count)
      end
      it 'returns an unprocessable entity response' do
        allow(Profile).to receive(:find_by).and_return(user.profile)
        allow(user.profile).to receive(:update).and_return(false)
        make_profile_patch_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe "DELETE '/profiles'" do
    let!(:user) { create(:user).tap { |user| user.create_profile(is_active: true) } }
    subject(:make_profile_delete_request) {
      delete "/profiles/#{user.profile.id}"
    }
    it 'deletes the profile' do
      expect {
        make_profile_delete_request
      }.to change(Profile, :count).by(-1)
    end
    it 'returns a sucessful response' do
      make_profile_delete_request
      expect(response).to have_http_status(:no_content)
    end
    it 'returns a unprocessable entity response' do
      allow(Profile).to receive(:find_by).and_return(user.profile)
        allow(user.profile).to receive(:destroy).and_return(false)

      make_profile_delete_request
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
