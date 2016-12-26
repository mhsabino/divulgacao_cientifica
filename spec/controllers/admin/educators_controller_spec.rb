require 'rails_helper'

RSpec.describe Admin::EducatorsController, type: :controller do
  let(:model)      { Educator }
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

  before do
    sign_in user
    allow(controller).to receive(:current_university).and_return(university)
  end

  describe '#index' do
    describe '#template' do
      let(:action) { :index }

      before { get :index }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      let!(:other_educator) { create(:educator) }
      let!(:educators) do
        create_list(:educator, 2, user: create(:user, :educator),
          university: university)
      end

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

    describe '#pagination' do
      let(:per_page)             { Admin::EducatorsController::PER_PAGE }
      let(:controller_resources) { controller.educators }
      let!(:resources) do
        create_list(:educator, 11, university: university)
      end

      before { get :index }

      include_examples 'admin_pagination'
    end

    describe '#search' do
      let!(:searched_educator) do
        create(:educator, name: 'searched_name',
          registration: 'searched_registration', university: university)
      end

      let(:search) { '' }

      before do
        educators
        get :index, search: search
      end

      context 'empty search' do
        it do
          expect(controller.educators)
            .to match_array(educators.push(searched_educator))
        end
      end

      context 'by name' do
        let(:search) { 'searched_name' }

        it { expect(controller.educators).to match_array([searched_educator]) }
      end

      context 'by registration' do
        let(:search) { 'searched_registration' }

        it { expect(controller.educators).to match_array([searched_educator]) }
      end
    end

    describe '#filter' do
      let!(:courses) { create_list(:course, 2, university: university) }
      let!(:filtered_educator) do
        create(:educator, university: university, course: courses.first)
      end

      let(:filter) { { course: '' } }

      before do
        educators
        get :index, filter: filter
      end

      context 'empty filter' do
        it do
          expect(controller.educators)
            .to match_array(educators.push(filtered_educator))
        end
      end

      context 'by course' do
        let(:filter) { { course: "#{courses.first.id}" } }

        it { expect(controller.educators).to match_array([filtered_educator]) }
      end
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
      it { expect(controller.educator).to be_a_new(model) }
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
      let(:model_symbol)  { :educator }
      let(:action)        { :create }

      include_examples 'admin_permited_params'
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.educators.create.success') }

      include_examples 'admin_create_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.educators.create.error') }

      include_examples 'admin_create_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_create_permission'
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
      { params: { id: educator.id, educator: valid_attributes } }
    end
    let(:invalid_params) do
      { params: { id: educator.id, educator: invalid_attributes } }
    end

    context 'permitted params' do
      let(:model_symbol)  { :educator }
      let(:action)        { :update }

      include_examples 'admin_permited_params'
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.educators.update.success') }

      include_examples 'admin_update_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.educators.update.error') }

      include_examples 'admin_update_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_update_permission'
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
      let(:expected_flash) { I18n.t('admin.educators.destroy.success') }

      include_examples 'admin_destroy_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.educators.destroy.error') }

      include_examples 'admin_destroy_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_destroy_permission'
    end
  end

end
