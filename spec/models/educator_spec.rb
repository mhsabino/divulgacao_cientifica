require 'rails_helper'

RSpec.describe Educator, type: :model do

  describe '#factory' do
    subject { build(:educator) }
    it { is_expected.to be_valid }
  end

  describe '#associations' do
    it { is_expected.to belong_to :university }
    it { is_expected.to belong_to :course }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :registration }
    it { is_expected.to validate_presence_of :university }
    it do
      is_expected.to validate_uniqueness_of(:registration)
        .scoped_to(:university_id)
    end
  end

  describe '#delegations' do
    it do
      is_expected.to delegate_method(:name).to(:university).with_prefix(true)
    end
    it do
      is_expected.to delegate_method(:name).to(:course).with_prefix(true)
    end
  end
end