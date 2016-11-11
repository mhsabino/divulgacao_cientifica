require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe "current_university" do
    let!(:university) { create(:university) }

    it "returns first University" do
      expect(controller.current_university).to eq(university)
    end
  end

end
