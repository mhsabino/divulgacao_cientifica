RSpec.shared_examples "admin_update_permission" do
  let(:role)              { :secretary }
  let(:other_user)        { create(:user, role: role) }
  let(:object_attributes) { valid_attributes.except('id', 'updated_at') }
  let(:object_id)         { valid_params[:params][:id] }
  let(:object)            { model.find(object_id) }
  let(:model_pluralized)  { model.to_s.downcase.pluralize }
  let(:show_path) do
    url_for(controller: "admin/#{model_pluralized}",
        id: object.id, action: 'show', only_path: true)
  end

  before do
    sign_out user
    sign_in other_user
    patch :update, valid_params
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
    before { object.reload }

    it { is_expected.to redirect_to show_path }
    it { expect(object).to have_attributes(object_attributes) }
  end

  context 'when a admin user tries to access' do
    let(:role) { :admin }

    before { object.reload }

    it { is_expected.to redirect_to show_path }
    it { expect(object).to have_attributes(object_attributes) }
  end
end

