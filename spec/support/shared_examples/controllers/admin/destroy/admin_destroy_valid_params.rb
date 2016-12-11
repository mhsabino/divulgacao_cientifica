RSpec.shared_examples "admin_destroy_valid_params" do
  it do
    expect{ delete :destroy, valid_params }
      .to change{ model.count }.by(-1)
  end

  context 'shows flash' do
    before { delete :destroy, valid_params }

    it { expect(controller).to set_flash[:notice].to(expected_flash) }
  end
end
