require 'rails_helper'

RSpec.describe Admin::SchoolClassesController, type: :controller do
  let(:model)        { SchoolClass }
  let(:user)         { create(:user) }
  let(:university)   { create(:university) }
  let(:course)       { create(:course, university: university) }
  let(:school_class) { school_classes.first }
  let(:permitted_params) do
    [
      :course_id,
      :year,
      :period,
      :vacancies,
      :name,
      :course_id,
      student_attributes: [:id, :name, :registration]
    ]
  end
  let(:school_classes) do
    create_list(:school_class, 2, course: course, university: university)
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
      let!(:other_school_class) { create(:school_class) }
      let!(:school_classes) do
        create_list(:school_class, 2, course: course, university: university)
      end

      before { get :index }

      it { expect(controller.school_classes).to match_array(school_classes) }
    end

    describe '#helper_methods' do
      let(:fields) { ['name', 'course_name', 'year', 'vacancies', 'period'] }
      let(:path)   { 'views/admin/school_classes/index' }

      before { get :index }

      include_examples 'admin_fields_helper_method'
      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#pagination' do
      let(:per_page)             { Admin::SchoolClassesController::PER_PAGE }
      let(:controller_resources) { controller.school_classes }
      let!(:resources) do
        create_list(:school_class, (per_page + 1), course: course,
          university: university).sort! { |a,b| a.name <=> b.name }
      end

      before { get :index }

      include_examples 'admin_pagination'
    end

    describe '#search' do
      let!(:searched_school_class) do
        create(:school_class, name: 'searched_name', course: course,
          university: university)
      end

      let(:search) { '' }

      before do
        school_classes
        get :index, params: { search: search }
      end

      context 'empty search' do
        it do
          expect(controller.school_classes)
            .to match_array(school_classes.push(searched_school_class))
        end
      end

      context 'by name' do
        let(:search) { 'searched_name' }

        it do
          expect(controller.school_classes)
            .to match_array([searched_school_class])
        end
      end
    end

    describe '#filter' do
      let!(:courses) { create_list(:course, 2, university: university) }
      let!(:filtered_school_class) do
        create(:school_class, course: courses.first, university: university,
          period: :nightly, vacancies: 10, year: '2015')
      end

      let(:filter) { { course: '', year: '', vacancies: '', period: '' } }

      before do
        school_classes
        get :index, params: { filter: filter }
      end

      context 'empty filter' do
        it { expect(controller.school_classes).to match_array(school_classes) }
      end

      context 'by course' do
        let(:filter) { { course: "#{courses.first.id}", year: '2015' } }

        it do
          expect(controller.school_classes)
            .to match_array([filtered_school_class])
        end
      end

      context 'by year' do
        let(:filter) { { year: '2015' } }

        it do
          expect(controller.school_classes)
            .to match_array([filtered_school_class])
        end
      end

      context 'by period' do
        let(:filter) { { period: '2', year: '2015' } }

        it do
          expect(controller.school_classes)
            .to match_array([filtered_school_class])
        end
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
      it { expect(controller.school_class).to be_a_new(model) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/school_classes/new' }

      before { get :new }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_new_permission'
    end
  end

  describe '#create' do
    let(:valid_school_class) do
      build(:school_class, course: course, university: university)
    end
    let(:invalid_school_class) { build(:school_class, :invalid ) }
    let(:valid_attributes)     { valid_school_class.attributes }
    let(:invalid_attributes)   { invalid_school_class.attributes }
    let(:valid_params) do
      { params: { school_class: valid_attributes } }
    end
    let(:invalid_params) do
      { params: { school_class: invalid_attributes } }
    end

    context 'permitted params' do
      let(:model_symbol)  { :school_class }
      let(:action)        { :create }

      include_examples 'admin_permited_params'
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.school_classes.create.success') }

      include_examples 'admin_create_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.school_classes.create.error') }

      include_examples 'admin_create_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_create_permission'
    end
  end

  describe '#show' do
    let(:valid_params) { { params: { id: school_class } } }

    describe '#template' do
      let(:action) { :show }

      before { get :show, valid_params }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :show, valid_params }
      it { expect(controller.school_class).to eq(school_class) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/school_classes/show' }

      before { get :show, valid_params }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_show_permission'
    end
  end

  describe '#edit' do
    let(:valid_params) { { params: { id: school_class.id } } }

    describe '#template' do
      let(:action) { :edit }

      before { get :edit, valid_params }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :edit, valid_params }
      it { expect(controller.school_class).to eq(school_class) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/school_classes/edit' }

      before { get :edit, valid_params }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_edit_permission'
    end
  end

  describe '#update' do
    let(:valid_school_class) do
      build(:school_class, course: course, created_at: school_class.created_at,
        university: university)
    end
    let(:invalid_school_class) do
      build(:school_class, :invalid, course: course)
    end
    let(:valid_attributes)   { valid_school_class.attributes }
    let(:invalid_attributes) { invalid_school_class.attributes }
    let(:valid_params) do
      { params: { id: school_class.id, school_class: valid_attributes } }
    end
    let(:invalid_params) do
      { params: { id: school_class.id, school_class: invalid_attributes } }
    end

    context 'permitted params' do
      let(:model_symbol)  { :school_class }
      let(:action)        { :update }

      include_examples 'admin_permited_params'
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.school_classes.update.success') }

      include_examples 'admin_update_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.school_classes.update.error') }

      include_examples 'admin_update_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_update_permission'
    end
  end

  describe '#destroy' do
    let!(:school_class) { create(:school_class) }
    let(:valid_params)  { { params: { id: school_class.id } } }

    context 'always' do
      before { delete :destroy, valid_params }

      it { is_expected.to redirect_to action: :index }
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.school_classes.destroy.success') }

      include_examples 'admin_destroy_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.school_classes.destroy.error') }

      include_examples 'admin_destroy_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_destroy_permission'
    end
  end

end
