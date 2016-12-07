require 'rails_helper'

RSpec.describe Admin::EducatorsController, type: :controller do
  let(:user)       { create(:user) }
  let(:university) { create(:university) }
  let(:educator)   { educators.first }
  let(:permitted_params) do
    [
      :name,
      :registration,
      :course_id,
      user_attributes: [:id, :email, :password, :password_confirmation]
    ]
  end
  let(:educators) do
    create_list(:educator, 2, user: create(:user, :educator),
      university: university)
  end

  before { sign_in user }

  describe '#index' do
    describe '#template' do
      before { get :index }
      render_views

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :index }
    end

    describe '#exposes' do
      before { get :index }
      it { expect(controller.educators).to match_array(educators) }
    end

    describe '#helper_methods' do
      describe 'fields' do
        let(:expected_result) { ['registration', 'name'] }

        it 'fields' do
          expect(controller.send(:fields)).to eq(expected_result)
        end
      end
    end

    describe '#permissions' do
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
  end

  describe '#new' do
    describe '#template' do
      before { get :new }
      render_views

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :new }
    end

    describe '#exposes' do
      before { get :new }
      it { expect(controller.educator).to be_a_new(Educator) }
    end

    describe '#permissions' do
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

      before do
        sign_out user
        sign_in other_user
        get :new
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
        it { is_expected.to render_template :new }
      end

      context 'when a admin user tries to access' do
        let(:role) { :admin }
        it { is_expected.to render_template :new }
      end
    end
  end

  describe '#create' do
    let(:valid_educator)   { build(:educator) }
    let(:invalid_educator) { build(:educator, :invalid ) }
    let(:valid_attributes) do
      valid_educator.attributes
        .merge!({ user_attributes: build(:user).attributes
          .merge!({ password: 'letmein' }) })
    end
    let(:invalid_attributes) do
      invalid_educator.attributes
        .merge!({ user_attributes: build(:user).attributes })
    end
    let(:valid_params)   { { params: { educator: valid_attributes } } }
    let(:invalid_params) { { params: { educator: invalid_attributes } } }

    context 'permitted params' do
      it do
        is_expected.to permit(*permitted_params)
          .for(:create, params: valid_params).on(:educator)
      end
    end

    context 'with valid params' do
      before { post :create, valid_params }

      it { is_expected.to redirect_to action: :index }
    end

    context 'with invalid params' do
      before { post :create, invalid_params }

      it { is_expected.to render_template :new }
    end

    describe '#permissions' do
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

      before do
        sign_out user
        sign_in other_user
        post :create, valid_params
      end

      context 'when a student user tries to access' do
        let(:role) { :student }
        it { is_expected.to redirect_to admin_root_path }
      end

      context 'when a educator user tries to access' do
        let(:role) { :educator }
        it { is_expected.to redirect_to admin_root_path }
      end
    end
  end

  describe '#show' do
    describe '#template' do
      before { get :show, params: { id: educator } }
      render_views

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :show }
    end

    describe '#exposes' do
      before { get :show, params: { id: educator } }
      it { expect(controller.educator).to eq(educator) }
    end

    describe '#permissions' do
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

      before do
        sign_out user
        sign_in other_user
        get :show, params: { id: educator }
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
        it { is_expected.to render_template :show }
      end

      context 'when a admin user tries to access' do
        let(:role) { :admin }
        it { is_expected.to render_template :show }
      end
    end
  end

  describe '#edit' do
    describe '#template' do
      before { get :edit, params: { id: educator } }
      render_views

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :edit }
    end

    describe '#exposes' do
      before { get :edit, params: { id: educator } }
      it { expect(controller.educator).to eq(educator) }
    end

    describe '#permissions' do
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

      before do
        sign_out user
        sign_in other_user
        get :edit, params: { id: educator }
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
        it { is_expected.to render_template :edit }
      end

      context 'when a admin user tries to access' do
        let(:role) { :admin }
        it { is_expected.to render_template :edit }
      end
    end
  end

  describe '#update' do
    let(:valid_educator)     { create(:educator, user: user) }
    let(:invalid_educator)   { build(:educator, :invalid, user: user) }
    let(:valid_attributes)   { valid_educator.attributes }
    let(:invalid_attributes) { invalid_educator.attributes }
    let(:valid_params) do
      { params: { id: educator, educator: valid_attributes } }
    end
    let(:invalid_params) do
      { params: { id: educator, educator: invalid_attributes } }
    end

    context 'permitted params' do
      it do
        is_expected.to permit(*permitted_params)
          .for(:update, valid_params).on(:educator)
      end
    end

    context 'with valid params' do
      before { patch :update, valid_params }

      it { is_expected.to redirect_to action: :show }
    end

    context 'with invalid params' do
      before { patch :update, invalid_params }

      it { is_expected.to render_template :edit }
    end

    describe '#permissions' do
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

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
    end
  end

  describe '#destroy' do
    let!(:educator) { create(:educator) }

    context 'always' do
      before { delete :destroy, params: { id: educator } }

      it { is_expected.to redirect_to action: :index }
    end

    context 'with valid params' do
      it do
        expect{ delete :destroy, params: { id: educator } }
          .to change{ Educator.count }.by(-1)
      end
    end

    context 'with invalid params' do
      before do
        allow_any_instance_of(Educator).to receive(:destroy).and_return(false)
      end

      it do
        expect{ delete :destroy, params: { id: educator } }
          .not_to change{ Educator.count }
      end
    end

    describe '#permissions' do
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

      before do
        sign_out user
        sign_in other_user
        delete :destroy, params: { id: educator }
      end

      context 'when a student user tries to access' do
        let(:role) { :student }
        it { is_expected.to redirect_to admin_root_path }
      end

      context 'when a educator user tries to access' do
        let(:role) { :educator }
        it { is_expected.to redirect_to admin_root_path }
      end
    end
  end

end
