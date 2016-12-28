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
    it { is_expected.to belong_to :university }
    it { is_expected.to have_many :students }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :course_id }
    it { is_expected.to validate_presence_of :year }
    it { is_expected.to validate_presence_of :period }
    it { is_expected.to validate_presence_of :university }
    it do
      is_expected.to validate_numericality_of(:vacancies).is_greater_than(0)
    end
  end

  describe '#delegations' do
    it do
      is_expected.to delegate_method(:name).to(:course).with_prefix(true)
    end
  end

  describe '#nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:students) }
  end

  describe 'methods' do
    let(:university) { create(:university) }
    let(:course)     { create(:course, university: university) }

    describe 'by_name' do
      let(:name)                { 'Name_' }
      let!(:school_classes)     { create_list(:school_class, 2) }
      let!(:other_school_class) { create(:school_class, name: 'other') }

      it { expect(described_class.by_name(name)).to match_array(school_classes) }
    end

    describe 'by_university' do
      let!(:other_school_class) { create(:school_class) }
      let!(:school_classes) do
        create_list(:school_class, 2, university: university)
      end

      it do
        expect(described_class.by_university(university.id))
          .to match_array(school_classes)
      end
    end

    describe 'by_course' do
      let!(:other_school_class) { create(:school_class) }
      let!(:school_classes) do
        create_list(:school_class, 2, course: course)
      end

      it { expect(described_class.by_course(course.id)).to match_array(school_classes) }
    end

    describe 'search' do
      let!(:school_classes) { create_list(:school_class, 2, course: course) }

      context 'when search_term is present' do
        let(:search_term) { 'searched' }
        let(:collection)  { described_class.all }
        let!(:school_class_searched_by_name) do
          create(:school_class, course: course, name: 'searched_name')
        end
        let(:expected_result) { [school_class_searched_by_name] }

        it do
          expect(described_class.search(collection, search_term))
            .to match_array(expected_result)
        end
      end

      context 'when search_term is not present' do
        let(:search_term) { '' }
        let(:collection)  { described_class.all }

        it do
          expect(described_class.search(collection, search_term))
            .to match_array(school_classes)
        end
      end
    end

    describe 'order_by_name' do
      let!(:first_school_class)  { create(:school_class, name: 'B_name') }
      let!(:second_school_class) { create(:school_class, name: 'A_name') }
      let(:expected_result)      { [second_school_class, first_school_class] }

      it { expect(described_class.order_by_name).to eq(expected_result) }
    end

    describe '#period_str' do
      let(:school_class) { create(:school_class) }
      let(:expected) do
        described_class.human_attribute_name("period.#{school_class.period}")
      end

      it { expect(school_class.period_str).to eq expected }
    end

    describe '#localized_periods' do
      let(:expected) do
        [
          [described_class.human_attribute_name('period.integral'), 'integral'],
          [described_class.human_attribute_name('period.nightly'), 'nightly']
        ]
      end

      subject { described_class.localized_periods }

      it { is_expected.to match_array expected }
    end
  end
end
