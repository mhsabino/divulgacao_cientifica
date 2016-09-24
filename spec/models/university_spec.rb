require 'rails_helper'

RSpec.describe University, type: :model do

  describe '#factory' do
    subject { build(:university) }
    it { is_expected.to be_valid }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
  end
end
