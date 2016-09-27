require 'rails_helper'

RSpec.describe ScientificResearch, type: :model do

  describe '#factory' do
    subject { build(:scientific_research) }
    it { is_expected.to be_valid }
  end

  describe '#associations' do
    it { is_expected.to belong_to :university }
    it { is_expected.to belong_to :educator }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :educator }
    it { is_expected.to validate_presence_of :university }
  end

  describe '#delegations' do
    it do
      is_expected.to delegate_method(:name).to(:university).with_prefix(true)
    end
    it do
      is_expected.to delegate_method(:name).to(:educator).with_prefix(true)
    end
  end
end
