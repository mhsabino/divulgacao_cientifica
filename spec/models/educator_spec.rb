require 'rails_helper'

RSpec.describe Educator, type: :model do
  subject { build(:educator) }

  describe '#factory' do
    it { is_expected.to be_valid }
  end

  describe '#associations' do
    it { is_expected.to belong_to :university }
    it { is_expected.to belong_to :course }
    it { is_expected.to belong_to(:user).dependent(:destroy) }
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

  describe 'methods' do
    let(:university) { create(:university) }

    describe 'by_name' do
      let(:name)            { 'Name_' }
      let!(:educators)      { create_list(:educator, 2) }
      let!(:other_educator) { create(:educator, name: 'other') }

      it { expect(Educator.by_name(name)).to match_array(educators) }
    end

    describe 'by_registration' do
      let(:registration)    { 'registration_' }
      let!(:educators)      { create_list(:educator, 2) }
      let!(:other_educator) { create(:educator, registration: 'other') }

      it do
        expect(Educator.by_registration(registration))
          .to match_array(educators)
      end
    end

    describe 'by_course' do
      let(:course)          { create(:course, university: university) }
      let!(:other_educator) { create(:educator, university: university) }
      let!(:educators) do
        create_list(:educator, 2, university: university, course: course)
      end

      it { expect(Educator.by_course(course.id)).to match_array(educators) }
    end

    describe 'by_university' do
      let!(:other_educator) { create(:educator) }
      let!(:educators)      { create_list(:educator, 2, university: university) }

      it do
        expect(Educator.by_university(university.id)).to match_array(educators)
      end
    end

    describe 'search' do
      let!(:educators)  { create_list(:educator, 2, university: university) }

      context 'when search_term is present' do
        let(:search_term) { 'searched' }
        let(:collection)  { Educator.all }
        let!(:educator_searched_by_name) do
          create(:educator, university: university, name: 'searched_name')
        end
        let!(:educator_searched_by_registration) do
          create(:educator, university: university,
            registration: 'searched_registration')
        end
        let(:expected_result) do
          [educator_searched_by_name, educator_searched_by_registration]
        end

        it do
          expect(Educator.search(collection, search_term))
            .to match_array(expected_result)
        end
      end

      context 'when search_term is not present' do
        let(:search_term) { '' }
        let(:collection)  { Educator.all }

        it do
          expect(Educator.search(collection, search_term))
            .to match_array(educators)
        end
      end
    end

    describe 'order_by_name' do
      let!(:first_educator)  { create(:educator, name: 'B_name') }
      let!(:second_educator) { create(:educator, name: 'A_name') }
      let(:expected_result)  { [second_educator, first_educator] }

      it { expect(Educator.order_by_name).to eq(expected_result) }
    end
  end
end
