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
    let(:university) { create(:university) }

    describe 'by_name' do
      let(:name)          { 'Name_' }
      let!(:courses)      { create_list(:course, 2) }
      let!(:other_course) { create(:course, name: 'other') }

      it { expect(described_class.by_name(name)).to match_array(courses) }
    end

    describe 'by_university' do
      let!(:other_course) { create(:course) }
      let!(:courses)      { create_list(:course, 2, university: university) }

      it do
        expect(described_class.by_university(university.id)).to match_array(courses)
      end
    end

    describe 'search' do
      let!(:courses)  { create_list(:course, 2, university: university) }

      context 'when search_term is present' do
        let(:search_term) { 'searched' }
        let(:collection)  { described_class.all }
        let!(:course_searched_by_name) do
          create(:course, university: university, name: 'searched_name')
        end
        let(:expected_result) { [course_searched_by_name] }

        it do
          expect(collection.search(search_term))
            .to match_array(expected_result)
        end
      end

      context 'when search_term is not present' do
        let(:search_term) { '' }
        let(:collection)  { described_class.all }

        it do
          expect(collection.search(search_term))
            .to match_array(courses)
        end
      end
    end

    describe 'order_by_name' do
      let!(:first_course)   { create(:course, name: 'B_name') }
      let!(:second_course)  { create(:course, name: 'A_name') }
      let(:expected_result) { [second_course, first_course] }

      it { expect(described_class.order_by_name).to eq(expected_result) }
    end
  end

end
