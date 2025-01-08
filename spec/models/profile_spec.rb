require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to allow_value(true).for(:is_active) }
  end
end
