RSpec.shared_examples "admin_update_valid_params" do
  before { patch :update, valid_params }

  it { is_expected.to redirect_to action: :show }
  it { expect(controller).to set_flash[:notice].to(expected_flash) }
end
