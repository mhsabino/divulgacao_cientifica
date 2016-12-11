RSpec.shared_examples "admin_fields_helper_method" do
  describe 'fields' do
    it 'fields' do
      expect(controller.send(:fields)).to eq(fields)
    end
  end
end
