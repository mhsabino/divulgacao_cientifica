RSpec.shared_examples "admin_destroy_permission" do
  let(:role)       { :secretary }
  let(:other_user) { create(:user, role: role) }
  let(:model_pluralized) { model.to_s.underscore.downcase.pluralize }
  let(:index_path) do
    url_for(controller: "admin/#{model_pluralized}", only_path: true)
  end

  before do
    sign_out user
    sign_in other_user
    delete :destroy, valid_params
  end

  context 'when a student user tries to access' do
    let(:role) { :student }
    it { is_expected.to redirect_to admin_root_path }
  end

  context 'when a educator user tries to access' do
    let(:role) { :educator }
    it { is_expected.to redirect_to admin_root_path }
  end

  context 'when a secretary user tries to access' do
    it { is_expected.to redirect_to index_path }
    it do
      expect{ model.find(object.id) }
        .to raise_exception{ ActiveRecord::RecordNotFound }
    end
  end

  context 'when a admin user tries to access' do
    let(:role) { :admin }

    it { is_expected.to redirect_to index_path }
    it do
      expect{ model.find(object.id) }
        .to raise_exception{ ActiveRecord::RecordNotFound }
    end
  end
end
