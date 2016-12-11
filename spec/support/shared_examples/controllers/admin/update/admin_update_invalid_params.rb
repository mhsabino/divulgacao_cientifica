RSpec.shared_examples "admin_update_invalid_params" do
  before { patch :update, invalid_params }

  it { is_expected.to render_template :edit }
  it { expect(controller).to set_flash[:alert].to(expected_flash) }
end
