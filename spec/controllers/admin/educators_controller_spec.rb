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
      let(:action) { :index }

      before { get :index }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :index }
      it { expect(controller.educators).to match_array(educators) }
    end

    describe '#helper_methods' do
      let(:fields) { ['registration', 'name'] }
      let(:path)   { 'views/admin/educators/index' }

      before { get :index }

      include_examples 'admin_fields_helper_method'
      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_index_permission'
    end
  end

  describe '#new' do
    describe '#template' do
      let(:action) { :new }

      before { get :new }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :new }
      it { expect(controller.educator).to be_a_new(Educator) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/educators/new' }

      before { get :new }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_new_permission'
    end
  end

  describe '#create' do
    let(:valid_educator)   { build(:educator, university: university) }
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
      let(:expected_flash) { I18n.t('admin.educators.create.success') }

      before { post :create, valid_params }

      it { is_expected.to redirect_to action: :index }
      it { expect(controller).to set_flash[:notice].to(expected_flash) }
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.educators.create.error') }

      before { post :create, invalid_params }

      it { is_expected.to render_template :new }
      it { expect(controller).to set_flash[:alert].to(expected_flash) }
    end

    describe '#permissions' do
      include_examples 'admin_create_permission', Educator
    end
  end

  describe '#show' do
    let(:valid_params) { { params: { id: educator } } }

    describe '#template' do
      let(:action) { :show }

      before { get :show, valid_params }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :show, valid_params }
      it { expect(controller.educator).to eq(educator) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/educators/show' }

      before { get :show, valid_params }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_show_permission'
    end
  end

  describe '#edit' do
    let(:valid_params) { { params: { id: educator.id } } }

    describe '#template' do
      let(:action) { :edit }

      before { get :edit, valid_params }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :edit, valid_params }
      it { expect(controller.educator).to eq(educator) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/educators/edit' }

      before { get :edit, valid_params }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_edit_permission'
    end
  end

  describe '#update' do
    let(:valid_educator) do
      build(:educator, user: educator.user, university: university,
        created_at: educator.created_at)
    end
    let(:invalid_educator) do
      build(:educator, :invalid, user: user, university: university)
    end
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
      let(:expected_flash) { I18n.t('admin.educators.update.success') }

      before { patch :update, valid_params }

      it { is_expected.to redirect_to action: :show }
      it { expect(controller).to set_flash[:notice].to(expected_flash) }
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.educators.update.error') }

      before { patch :update, invalid_params }

      it { is_expected.to render_template :edit }
      it { expect(controller).to set_flash[:alert].to(expected_flash) }
    end

    describe '#permissions' do
      include_examples 'admin_update_permission', Educator
    end
  end

  describe '#destroy' do
    let!(:educator)    { create(:educator) }
    let(:valid_params) { { params: { id: educator.id } } }

    context 'always' do
      before { delete :destroy, valid_params }

      it { is_expected.to redirect_to action: :index }
    end

    context 'with valid params' do
      it do
        expect{ delete :destroy, valid_params }
          .to change{ Educator.count }.by(-1)
      end

      context 'shows flash' do
        let(:expected_flash) { I18n.t('admin.educators.destroy.success') }

        before { delete :destroy, valid_params }

        it { expect(controller).to set_flash[:notice].to(expected_flash) }
      end
    end

    context 'with invalid params' do
      before do
        allow_any_instance_of(Educator).to receive(:destroy).and_return(false)
      end

      it do
        expect{ delete :destroy, valid_params }
          .not_to change{ Educator.count }
      end

      context 'shows flash' do
        let(:expected_flash) { I18n.t('admin.educators.destroy.error') }

        before { delete :destroy, valid_params }

        it { expect(controller).to set_flash[:alert].to(expected_flash) }
      end
    end

    describe '#permissions' do
      include_examples 'admin_destroy_permission', Educator
    end
  end

end
