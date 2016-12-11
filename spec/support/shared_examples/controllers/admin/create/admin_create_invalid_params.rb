RSpec.shared_examples "admin_create_invalid_params" do
  before { post :create, invalid_params }

  it { is_expected.to render_template :new }
  it { expect(controller).to set_flash[:alert].to(expected_flash) }
end
