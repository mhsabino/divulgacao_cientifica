require 'rails_helper'

RSpec.describe Classroom, type: :model do

  describe '#factory' do
    subject { build(:classroom) }
    it { is_expected.to be_valid }
  end

  describe 'enums' do
    it do
      is_expected.to define_enum_for(:period)
        .with({ integral: 1, nightly: 2 })
    end
  end

  describe '#associations' do
    it { is_expected.to belong_to :discipline }
    it { is_expected.to belong_to :educator }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :period }
    it { is_expected.to validate_presence_of :vacancies }
    it { is_expected.to validate_presence_of :year }
    it { is_expected.to validate_presence_of :discipline }
    it do
      is_expected.to validate_numericality_of(:vacancies).is_greater_than(0)
    end
  end

  describe '#delegations' do
    it do
      is_expected.to delegate_method(:name).to(:discipline).with_prefix(true)
    end
    it do
      is_expected.to delegate_method(:name).to(:educator).with_prefix(true)
    end
  end

end
