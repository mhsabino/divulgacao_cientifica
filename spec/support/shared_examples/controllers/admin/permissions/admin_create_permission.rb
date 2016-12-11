RSpec.shared_examples "admin_create_permission" do |model|
  let(:role)             { :secretary }
  let(:other_user)       { create(:user, role: role) }
  let(:model_pluralized) { model.to_s.downcase.pluralize }
  let(:index_path) do
    url_for(controller: "admin/#{model_pluralized}", only_path: true)
  end

  context 'when a student user tries to access' do
    let(:role) { :student }

    before do
      sign_out user
      sign_in other_user
      post :create, valid_params
    end

    it { is_expected.to redirect_to admin_root_path }
  end

  context 'when a educator user tries to access' do
    let(:role) { :educator }

    before do
      sign_out user
      sign_in other_user
      post :create, valid_params
    end

    it { is_expected.to redirect_to admin_root_path }
  end

  context 'when a secretary user tries to access' do
    before do
      sign_out user
      sign_in other_user
    end

    it { expect(post :create, valid_params).to redirect_to(index_path) }
    it { expect{ post :create, valid_params }.to change{ model.count }.by(1) }
  end

  context 'when a admin user tries to access' do
    let(:role) { :admin }

    before do
      sign_out user
      sign_in other_user
    end

    it { expect(post :create, valid_params).to redirect_to(index_path) }
    it { expect{ post :create, valid_params }.to change{ model.count }.by(1) }
  end
end
