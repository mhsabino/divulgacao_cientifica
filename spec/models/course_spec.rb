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
    it { is_expected.to have_many :disciplines }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :university }
    it do
      is_expected.to validate_uniqueness_of(:name)
        .scoped_to(:university_id)
    end
  end

  describe '#delegations' do
    it do
      is_expected.to delegate_method(:name).to(:university).with_prefix(true)
    end
  end

  describe 'methods' do
    describe 'by_name' do
      let(:name)          { 'Name_' }
      let!(:courses)      { create_list(:course, 2) }
      let!(:other_course) { create(:course, name: 'other') }

      it { expect(Course.by_name(name)).to match_array(courses) }
    end

    describe 'by_university' do
      let(:university)    { create(:university) }
      let!(:other_course) { create(:course) }
      let!(:courses)      { create_list(:course, 2, university: university) }

      it do
        expect(Course.by_university(university.id)).to match_array(courses)
      end
    end
  end

end
