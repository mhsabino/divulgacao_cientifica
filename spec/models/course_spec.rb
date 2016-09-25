require 'rails_helper'

RSpec.describe Course, type: :model do

  describe '#factory' do
    subject { build(:course) }
    it { is_expected.to be_valid }
  end

  describe '#associations' do
    it { is_expected.to belong_to :university }
    it { is_expected.to have_many :educators }
    it { is_expected.to have_many :school_classes }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :university }
  end

  describe '#delegations' do
    it do
      is_expected.to delegate_method(:name).to(:university).with_prefix(true)
    end
  end

end
