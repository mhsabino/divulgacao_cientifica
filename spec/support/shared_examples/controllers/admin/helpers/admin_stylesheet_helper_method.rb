RSpec.shared_examples "admin_stylesheet_helper_method" do
  describe 'stylesheet' do
    it { expect(controller.send(:stylesheet)).to eq(path) }
  end
end
