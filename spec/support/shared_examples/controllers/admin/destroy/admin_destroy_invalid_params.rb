RSpec.shared_examples "admin_destroy_invalid_params" do
  before do
    allow_any_instance_of(model).to receive(:destroy).and_return(false)
  end

  it do
    expect{ delete :destroy, valid_params }
      .not_to change{ model.count }
  end

  context 'shows flash' do
    before { delete :destroy, valid_params }

    it { expect(controller).to set_flash[:alert].to(expected_flash) }
  end
end
