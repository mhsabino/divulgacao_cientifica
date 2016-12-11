RSpec.shared_examples "admin_javascript_helper_method" do
  describe 'javascript' do
    it { expect(controller.send(:javascript)).to eq(path) }
  end
end
