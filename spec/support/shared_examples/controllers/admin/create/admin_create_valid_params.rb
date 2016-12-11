RSpec.shared_examples "admin_create_valid_params" do
  before { post :create, valid_params }

  it { is_expected.to redirect_to action: :create }
  it { expect(controller).to set_flash[:notice].to(expected_flash) }
end
