require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:cpf) }
    it { should validate_presence_of(:birthdate) }
    it { should allow_value("2024-12-12").for(:birthdate) }
    it { should have_one(:profile).dependent(:destroy) }
  end
end
