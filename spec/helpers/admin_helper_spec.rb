require 'rails_helper'

RSpec.describe AdminHelper, type: :helper do

  describe '#link_to_remove' do
    let(:educator) { create(:educator) }
    let(:path)     { admin_educator_path(educator) }
    let(:expected_result) do
      link_to path, { data: { toggle: 'tooltip',
        title: t('tooltip_remove_action'),
        confirm: t('destroy_confirmation') } }, method: "delete" do
        content_tag(:i, nil, class: 'fa fa-trash-o')
      end
    end

    it do
      expect(helper.link_to_remove(path)).to eq(expected_result)
    end
  end

  describe '#link_to_edit' do
    let(:educator) { create(:educator) }
    let(:path)     { edit_admin_educator_path(educator) }
    let(:expected_result) do
      link_to path, { data: { toggle: 'tooltip', title: t('tooltip_edit_action') } } do
        content_tag(:i, nil, class: 'fa fa-pencil-square-o')
      end
    end

    it do
      expect(helper.link_to_edit(path)).to eq(expected_result)
    end
  end

end
