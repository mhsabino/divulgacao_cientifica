require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'enums' do
    it do
      is_expected.to define_enum_for(:role)
        .with({ admin: 1, secretary: 2, educator: 3, student: 4 })
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to validate_presence_of :role }

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
