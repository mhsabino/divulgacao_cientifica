RSpec.shared_examples "admin_breadcrumb_helper_method" do
  it { expect(controller.send(:breadcrumbs).first.name).to eq(resource) }
  it { expect(controller.send(:breadcrumbs).first.path).to eq(path) }
end
