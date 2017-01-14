require 'rails_helper'

RSpec.describe Admin::SchoolClasses::SchoolClassesHelper, type: :helper do

  describe 'can_remove_school_class?' do
    let(:university) { create(:university) }
    let(:school_class)     { create(:school_class, university: university) }

    context 'when school_class is not present' do
      let(:school_class) { nil }

      it { expect(helper.can_remove_school_class?(school_class)).to eq(false) }
    end

    context 'when school_class has students' do
      let!(:student) do
        create(:student, university: university, school_class: school_class)
      end

      it { expect(helper.can_remove_school_class?(school_class)).to eq(false) }
    end

    context 'when school_class has no association' do
      it { expect(helper.can_remove_school_class?(school_class)).to eq(true) }
    end
  end
end
