RSpec.shared_examples "admin_index_permission" do
  let(:role)       { :secretary }
  let(:other_user) { create(:user, role: role) }

  before do
    sign_out user
    sign_in other_user
    get :index
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
    it { is_expected.to render_template :index }
  end

  context 'when a admin user tries to access' do
    it { is_expected.to render_template :index }
  end
end
