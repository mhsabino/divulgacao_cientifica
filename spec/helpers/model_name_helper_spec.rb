require 'rails_helper'

RSpec.describe ModelNameHelper, type: :helper do
  describe '#downcase_localized_model_name' do
    context 'when model name is present' do
      let(:model)           { Educator }
      let(:expected_result) { 'educador' }

      it do
        expect(helper.downcase_localized_model_name(model))
          .to eq(expected_result)
      end
    end

    context 'when model name is not present' do
      let(:model) { nil }

      it do
        expect(helper.downcase_localized_model_name(model))
          .to eq(nil)
      end
    end
  end

  describe '#pluralized_localized_model_name' do
    context 'when model name is present' do
      let(:model)           { Educator }
      let(:expected_result) { 'Educadores' }

      it do
        expect(helper.pluralized_localized_model_name(model))
          .to eq(expected_result)
      end
    end

    context 'when model name is not present' do
      let(:model) { nil }

      it do
        expect(helper.pluralized_localized_model_name(model))
          .to eq(nil)
      end
    end
  end

  describe '#constantized_string_model_name' do
    context 'when model name is present' do
      let(:model)           { 'Educator' }
      let(:expected_result) { Educator }

      it do
        expect(helper.constantized_string_model_name(model))
          .to eq(expected_result)
      end
    end

    context 'when model name is not present' do
      let(:model) { nil }

      it do
        expect(helper.constantized_string_model_name(model))
          .to eq(nil)
      end
    end
  end

  describe '#pluralized_string_model_name' do
    context 'when model name is present' do
      let(:model)           { 'Educator' }
      let(:expected_result) { 'educators' }

      it do
        expect(helper.pluralized_string_model_name(model))
          .to eq(expected_result)
      end
    end

    context 'when model name is not present' do
      let(:model) { nil }

      it do
        expect(helper.pluralized_string_model_name(model))
          .to eq(nil)
      end
    end
  end
end
