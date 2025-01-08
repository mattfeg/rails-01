require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:cpf) }
    it { is_expected.to validate_presence_of(:birthdate) }
    it { is_expected.to allow_value("2024-12-12").for(:birthdate) }
    it { is_expected.to have_one(:profile).dependent(:destroy) }
  end
end
