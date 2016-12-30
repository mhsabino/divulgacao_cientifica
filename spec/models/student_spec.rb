require 'rails_helper'

RSpec.describe Student, type: :model do

  describe '#factory' do
    subject { build(:student) }
    it { is_expected.to be_valid }
  end

  describe '#associations' do
    it { is_expected.to belong_to :university }
    it { is_expected.to belong_to :school_class }
    it { is_expected.to belong_to :user }
    it { is_expected.to have_one(:course).through(:school_class) }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :registration }
    it { is_expected.to validate_presence_of :university }
    it { is_expected.to validate_presence_of :school_class_id }
    it { is_expected.to validate_presence_of :user }
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
      is_expected.to delegate_method(:name).to(:school_class).with_prefix(true)
    end
    it do
      is_expected.to delegate_method(:email).to(:user)
    end
  end

  describe '#nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:user) }
  end

  describe '#methods' do
    let(:university) { create(:university) }

    describe 'by_name' do
      let(:name)           { 'Name_' }
      let!(:students)      { create_list(:student, 2) }
      let!(:other_student) { create(:student, name: 'other') }

      it { expect(described_class.by_name(name)).to match_array(students) }
    end

    describe 'by_registration' do
      let(:registration)   { 'registration_' }
      let!(:students)      { create_list(:student, 2) }
      let!(:other_student) { create(:student, registration: 'other') }

      it do
        expect(described_class.by_registration(registration))
          .to match_array(students)
      end
    end

    describe 'by_school_class' do
      let(:school_class)   { create(:school_class, university: university) }
      let!(:other_student) { create(:student, university: university) }
      let!(:students) do
        create_list(:student, 2, university: university,
          school_class: school_class)
      end

      it do
        expect(described_class.by_school_class(school_class.id))
          .to match_array(students)
      end
    end

    describe 'by_university' do
      let!(:other_student) { create(:student) }
      let!(:students)      { create_list(:student, 2, university: university) }

      it do
        expect(described_class.by_university(university.id))
          .to match_array(students)
      end
    end

    describe 'search' do
      let!(:students)  { create_list(:student, 2, university: university) }

      context 'when search_term is present' do
        let(:search_term) { 'searched' }
        let(:collection)  { described_class.all }
        let!(:student_searched_by_name) do
          create(:student, university: university, name: 'searched_name')
        end
        let!(:student_searched_by_registration) do
          create(:student, university: university,
            registration: 'searched_registration')
        end
        let(:expected_result) do
          [student_searched_by_name, student_searched_by_registration]
        end

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
            .to match_array(students)
        end
      end
    end

    describe 'order_by_name' do
      let!(:first_student)   { create(:student, name: 'B_name') }
      let!(:second_student)  { create(:student, name: 'A_name') }
      let(:expected_result)  { [second_student, first_student] }

      it { expect(described_class.order_by_name).to eq(expected_result) }
    end
  end
end
