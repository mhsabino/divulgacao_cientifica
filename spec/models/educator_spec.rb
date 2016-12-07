require 'rails_helper'

RSpec.describe Educator, type: :model do
  subject { build(:educator) }

  describe '#factory' do
    it { is_expected.to be_valid }
  end

  describe '#associations' do
    it { is_expected.to belong_to :university }
    it { is_expected.to belong_to :course }
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :classrooms }
    it { is_expected.to have_many(:disciplines).through(:classrooms) }
    it { is_expected.to have_many :scientific_researches }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :registration }
    it { is_expected.to validate_presence_of :university }
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :course }
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
    it do
      is_expected.to delegate_method(:email).to(:user)
    end
  end

  describe '#nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:user) }
  end
end
