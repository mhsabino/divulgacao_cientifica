require 'rails_helper'

RSpec.describe Admin::EducatorsController, type: :controller do
  let(:user)             { create(:user) }
  let(:university)       { create(:university) }
  let(:educator)         { educators.first }
  let(:permitted_params) { [ :name, :registration, :course_id ] }
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
    let(:valid_educator)     { educator }
    let(:invalid_educator)   { build(:educator, :invalid ) }
    let(:valid_attributes)   { valid_educator.attributes  }
    let(:invalid_attributes) { invalid_educator.attributes }
    let(:valid_params)       { { educator: valid_attributes } }
    let(:invalid_params)     { { educator: invalid_attributes } }

    context 'permitted params' do
      it do
        is_expected.to permit(*permitted_params)
          .for(:create, params: valid_params).on(:educator)
      end
    end

    context 'with valid params' do
      before { post :create, valid_params }

      xit { is_expected.to redirect_to :index }
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

  describe '#edit' do
    describe '#template' do
      before { get :edit, id: educator }
      render_views

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :edit }
    end

    describe '#exposes' do
      before { get :edit, id: educator }
      it { expect(controller.educator).to eq(educator) }
    end

    describe '#permissions' do
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

      before do
        sign_out user
        sign_in other_user
        get :edit, id: educator
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
    let(:valid_attributes)   { valid_educator.attributes  }
    let(:invalid_attributes) { invalid_educator.attributes }
    let(:valid_params)       { { id: educator, educator: valid_attributes } }
    let(:invalid_params)     { { id: educator, educator: invalid_attributes } }

    context 'permitted params' do
      xit do
        is_expected.to permit(*permitted_params)
          .for(:update, params: valid_params).on(:educator)
      end
    end

    context 'with valid params' do
      before { patch :update, valid_params }

      it { is_expected.to redirect_to action: :show }
    end

    context 'with invalid params' do
      before { patch :update, invalid_params }

      xit { is_expected.to render_template :edit }
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

end
