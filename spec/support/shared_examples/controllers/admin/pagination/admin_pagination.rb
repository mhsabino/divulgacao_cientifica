RSpec.shared_examples "admin_pagination" do
  it { expect(controller_resources).to eq(resources.first(per_page)) }
end
