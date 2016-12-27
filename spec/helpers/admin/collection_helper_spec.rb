require 'rails_helper'

RSpec.describe Admin::CollectionHelper, type: :helper do

  describe '#courses_by_university' do
    let(:university)    { create(:university) }
    let!(:courses)      { create_list(:course, 2, university: university) }
    let!(:other_course) { create(:course) }

    it do
      expect(helper.courses_by_university(university)).to eq(courses)
    end
  end

end
