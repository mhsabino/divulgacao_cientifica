require 'rails_helper'

RSpec.describe Admin::TableHelper, type: :helper do

  describe 'display_admin_responsive_table' do
    let(:model)      { Educator }
    let(:collection) { create_list(:educator, 2) }
    let(:fields)     { %w(registration name) }

    it 'includes table' do
      expect(helper.display_admin_responsive_table(model, collection, fields))
        .to include('table')
    end

    it 'includes thead' do
      expect(helper.display_admin_responsive_table(model, collection, fields))
        .to include('thead')
    end

    it 'includes tbody' do
      expect(helper.display_admin_responsive_table(model, collection, fields))
        .to include('tbody')
    end
  end

end
