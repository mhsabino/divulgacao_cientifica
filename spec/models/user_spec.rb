require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }

    context 'uniqueness email' do
      let(:email)      { 'unique_email@email.com' }
      let!(:user)      { create(:user, email: email) }
      let(:other_user) { build(:user, email: email) }

      it do
        expect{ other_user.save }.not_to change{ User.count }
      end
    end
  end
end
