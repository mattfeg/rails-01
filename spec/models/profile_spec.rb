require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should allow_value(true).for(:is_active) }
  end
end
