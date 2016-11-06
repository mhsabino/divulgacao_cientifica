require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe '#downcase_model_name' do
    context 'when model name is present' do
      let(:model)           { Educator }
      let(:expected_result) { 'educador' }

      it do
        expect(helper.downcase_model_name(model))
          .to eq(expected_result)
      end
    end

    context 'when model name is not present' do
      let(:model)           { nil }
      let(:expected_result) { '' }

      it do
        expect(helper.downcase_model_name(model))
          .to eq(expected_result)
      end
    end
  end

end
