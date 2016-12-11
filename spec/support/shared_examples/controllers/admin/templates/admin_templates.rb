RSpec.shared_examples "admin_templates" do
  render_views

  it { is_expected.to respond_with :success }
  it { is_expected.to render_template action }
end
