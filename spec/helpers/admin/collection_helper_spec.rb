require 'rails_helper'

RSpec.describe Admin::CollectionHelper, type: :helper do
  let(:university) { create(:university) }

  describe '#courses_by_university' do
    let!(:courses)      { create_list(:course, 2, university: university) }
    let!(:other_course) { create(:course) }

    context 'when university is present' do
      it { expect(helper.courses_by_university(university)).to eq(courses) }
    end

    context 'when university is not present' do
      it { expect(helper.courses_by_university(nil)).to eq([]) }
    end
  end

  describe '#school_classes_years' do
    let!(:school_classes) do
      create_list(:school_class, 2, university: university, year: '2017')
    end
    let!(:other_school_class_from_same_university) do
      create(:school_class, university: university, year: '2016')
    end
    let!(:other_school_class) do
      create(:school_class, year: '2015')
    end

    context 'when university is present' do
      let(:expected_result) { [['2016','2016'],['2017','2017']] }

      it do
        expect(helper.school_classes_years(university)).to eq(expected_result)
      end
    end

    context 'when university is not present' do
      it { expect(helper.school_classes_years(nil)).to eq([]) }
    end
  end

end
