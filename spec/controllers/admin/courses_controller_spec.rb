require 'rails_helper'

RSpec.describe Admin::CoursesController, type: :controller do
  let(:model)            { Course }
  let(:user)             { create(:user) }
  let(:university)       { create(:university) }
  let(:course)           { courses.first }
  let(:permitted_params) { [ :name ] }
  let(:courses)          { create_list(:course, 2, university: university) }

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
      let!(:other_course) { create(:course) }

      before { get :index }

      it { expect(controller.courses).to match_array(courses) }
    end

    describe '#helper_methods' do
      let(:fields) { ['name'] }
      let(:path)   { 'views/admin/courses/index' }

      before { get :index }

      include_examples 'admin_fields_helper_method'
      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe 'pagination' do
      let(:per_page)             { Admin::CoursesController::PER_PAGE }
      let(:controller_resources) { controller.courses }
      let!(:resources) do
        create_list(:course, 11, university: university)
      end

      before { get :index }

      include_examples 'admin_pagination'
    end

    describe '#search' do
      let!(:searched_course) do
        create(:course, name: 'searched_name', university: university)
      end

      let(:search) { '' }

      before do
        courses
        get :index, params: { search: search }
      end

      context 'empty search' do
        it do
          expect(controller.courses)
            .to match_array(courses.push(searched_course))
        end
      end

      context 'by name' do
        let(:search) { 'searched_name' }

        it { expect(controller.courses).to match_array([searched_course]) }
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

      it { expect(controller.course).to be_a_new(model) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/courses/new' }

      before { get :new }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_new_permission'
    end
  end

  describe '#create' do
    let(:valid_course)       { build(:course, university: university) }
    let(:invalid_course)     { build(:course, :invalid ) }
    let(:valid_attributes)   { valid_course.attributes }
    let(:invalid_attributes) { invalid_course.attributes }
    let(:valid_params)       { { params: { course: valid_attributes } } }
    let(:invalid_params)     { { params: { course: invalid_attributes } } }

    context 'permitted params' do
      let(:model_symbol)  { :course }
      let(:action)        { :create }

      include_examples 'admin_permited_params'
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.courses.create.success') }

      include_examples 'admin_create_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.courses.create.error') }

      include_examples 'admin_create_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_create_permission'
    end
  end

  describe '#show' do
    let(:valid_params) { { params: { id: course.id } } }

    describe '#template' do
      let(:action) { :show }

      before { get :show, valid_params }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :show, valid_params }

      it { expect(controller.course).to eq(course) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/courses/show' }

      before { get :show, valid_params }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_show_permission'
    end
  end

  describe '#edit' do
    let(:valid_params) { { params: { id: course.id } } }

    describe '#template' do
      let(:action) { :edit }

      before { get :edit, valid_params }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :edit, valid_params }

      it { expect(controller.course).to eq(course) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/courses/edit' }

      before { get :edit, valid_params }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_edit_permission'
    end
  end

  describe '#update' do
    let(:valid_course) do
      build(:course, university: university, created_at: course.created_at)
    end
    let(:invalid_course) do
      build(:course, :invalid, university: university)
    end
    let(:valid_attributes)   { valid_course.attributes }
    let(:invalid_attributes) { invalid_course.attributes }
    let(:valid_params) do
      { params: { id: course.id, course: valid_attributes } }
    end
    let(:invalid_params) do
      { params: { id: course.id, course: invalid_attributes } }
    end

    context 'permitted params' do
      let(:model_symbol)  { :course }
      let(:action)        { :update }

      include_examples 'admin_permited_params'
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.courses.update.success') }

      include_examples 'admin_update_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.courses.update.error') }

      include_examples 'admin_update_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_update_permission'
    end
  end

  describe '#destroy' do
    let!(:course)      { create(:course) }
    let(:valid_params) { { params: { id: course.id } } }

    context 'always' do
      before { delete :destroy, valid_params }

      it { is_expected.to redirect_to action: :index }
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.courses.destroy.success') }

      include_examples 'admin_destroy_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.courses.destroy.error') }

      include_examples 'admin_destroy_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_destroy_permission'
    end
  end

end
