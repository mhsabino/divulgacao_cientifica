require 'rails_helper'

RSpec.describe SchoolClass, type: :model do

  describe '#factory' do
    subject { build(:school_class) }
    it { is_expected.to be_valid }
  end

  describe 'enums' do
    it do
      is_expected.to define_enum_for(:period)
        .with({ integral: 1, nightly: 2 })
    end
  end

  describe '#associations' do
    it { is_expected.to belong_to :course }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :course }
    it { is_expected.to validate_presence_of :year }
    it { is_expected.to validate_presence_of :period }
    it do
      is_expected.to validate_numericality_of(:vacancies).is_greater_than(0)
    end
  end

  describe '#delegations' do
    it do
      is_expected.to delegate_method(:name).to(:course).with_prefix(true)
    end
  end
end
