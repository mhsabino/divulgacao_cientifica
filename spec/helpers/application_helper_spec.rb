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
      let(:model) { nil }

      it do
        expect(helper.downcase_model_name(model))
          .to eq(nil)
      end
    end
  end

  describe 'current_year' do
    it { expect(helper.current_year).to eq(DateTime.now.year) }
  end

  describe 'flash_message' do
    context 'when notice message' do
      let(:notice_message) { 'message' }
      let(:flash_css)      { 'alert alert-success' }
      let(:flash_message)  { "<div class='#{flash_css}'>#{notice_message}</div>" }

      before { flash[:notice] = notice_message }

      it { expect(helper.flash_message).to eq(flash_message) }
    end

    context 'when info message' do
      let(:info_message)  { 'message' }
      let(:flash_css)     { 'alert alert-info' }
      let(:flash_message) { "<div class='#{flash_css}'>#{info_message}</div>" }

      before { flash[:info] = info_message }

      it { expect(helper.flash_message).to eq(flash_message) }
    end

    context 'when warning message' do
      let(:warning_message) { 'message' }
      let(:flash_css)       { 'alert alert-warning' }
      let(:flash_message)   { "<div class='#{flash_css}'>#{warning_message}</div>" }

      before { flash[:warning] = warning_message }

      it { expect(helper.flash_message).to eq(flash_message) }
    end

    context 'when alert message' do
      let(:alert_message) { 'message' }
      let(:flash_css)     { 'alert alert-danger' }
      let(:flash_message) { "<div class='#{flash_css}'>#{alert_message}</div>" }

      before { flash[:alert] = alert_message }

      it { expect(helper.flash_message).to eq(flash_message) }
    end
  end

end
