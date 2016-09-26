require 'rails_helper'

RSpec.describe Discipline, type: :model do

  describe '#factory' do
    subject { build(:discipline) }
    it { is_expected.to be_valid }
  end

  describe '#associations' do
    it { is_expected.to belong_to :university }
    it { is_expected.to belong_to :course }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :university }
    it { is_expected.to validate_presence_of :course }
    it do
      is_expected.to validate_uniqueness_of(:name)
        .scoped_to(:course_id)
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
