require 'rails_helper'

RSpec.describe Admin::Courses::CoursesHelper, type: :helper do

  describe 'can_remove_course?' do
    let(:university) { create(:university) }
    let(:course)     { create(:course, university: university) }

    context 'when course is not present' do
      let(:course) { nil }

      it { expect(helper.can_remove_course?(course)).to eq(false) }
    end

    context 'when course has school classes' do
      let!(:school_class) do
        create(:school_class, university: university, course: course)
      end

      it { expect(helper.can_remove_course?(course)).to eq(false) }
    end

    context 'when course has educators' do
      let!(:educator) do
        create(:educator, university: university, course: course)
      end

      it { expect(helper.can_remove_course?(course)).to eq(false) }
    end

    context 'when course has disciplines' do
      let!(:discipline) do
        create(:discipline, university: university, course: course)
      end

      it { expect(helper.can_remove_course?(course)).to eq(false) }
    end

    context 'when course has no association' do
      it { expect(helper.can_remove_course?(course)).to eq(true) }
    end
  end

end
