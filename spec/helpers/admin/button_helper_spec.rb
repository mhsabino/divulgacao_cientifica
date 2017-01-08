require 'rails_helper'

RSpec.describe Admin::ButtonHelper, type: :helper do

  describe 'new_resource_button' do
    let(:path)        { new_admin_student_path }
    let(:button_text) { I18n.t('.new') }
    let(:expected_result) do
      link_to button_text, path, class: 'btn btn-primary btn-block', role: "button"
    end

    it do
      expect(helper.new_resource_button(path, button_text)).to eq(expected_result)
    end
  end

end
