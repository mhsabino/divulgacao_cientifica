require 'rails_helper'

RSpec.describe Discipline, type: :model do

  describe '#factory' do
    subject { build(:discipline) }
    it { is_expected.to be_valid }
  end

  describe '#associations' do
    it { is_expected.to belong_to :university }
    it { is_expected.to belong_to :course }
    it { is_expected.to have_many :classrooms }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :university }
    it { is_expected.to validate_presence_of :course_id }
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

  describe 'methods' do
    let(:university) { create(:university) }

    describe 'by_name' do
      let(:name)              { 'Name_' }
      let!(:disciplines)      { create_list(:discipline, 2) }
      let!(:other_discipline) { create(:discipline, name: 'other') }

      it { expect(described_class.by_name(name)).to match_array(disciplines) }
    end

    describe 'by_course' do
      let(:course)            { create(:course, university: university) }
      let!(:other_discipline) { create(:discipline, university: university) }
      let!(:disciplines) do
        create_list(:discipline, 2, university: university, course: course)
      end

      it { expect(described_class.by_course(course.id)).to match_array(disciplines) }
    end

    describe 'by_university' do
      let!(:other_discipline) { create(:discipline) }
      let!(:disciplines)      { create_list(:discipline, 2, university: university) }

      it do
        expect(described_class.by_university(university.id)).to match_array(disciplines)
      end
    end

    describe 'search' do
      let!(:disciplines)  { create_list(:discipline, 2, university: university) }

      context 'when search_term is present' do
        let(:search_term) { 'searched' }
        let(:collection)  { described_class.all }
        let!(:discipline_searched_by_name) do
          create(:discipline, university: university, name: 'searched_name')
        end
        let(:expected_result) { [discipline_searched_by_name] }

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
            .to match_array(disciplines)
        end
      end
    end

    describe 'order_by_name' do
      let!(:first_discipline)  { create(:discipline, name: 'B_name') }
      let!(:second_discipline) { create(:discipline, name: 'A_name') }
      let(:expected_result)  { [second_discipline, first_discipline] }

      it { expect(described_class.order_by_name).to eq(expected_result) }
    end
  end
end
