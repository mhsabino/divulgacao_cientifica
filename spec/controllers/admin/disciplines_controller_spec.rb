require 'rails_helper'

RSpec.describe Admin::DisciplinesController, type: :controller do
  let(:model)      { Discipline }
  let(:user)       { create(:user) }
  let(:university) { create(:university) }
  let(:discipline) { disciplines.first }
  let(:permitted_params) do
    [
      :name,
      :course_id,
      :description
    ]
  end
  let(:disciplines) do
    create_list(:discipline, 2, university: university)
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
      let!(:other_discipline) { create(:discipline) }
      let!(:disciplines) do
        create_list(:discipline, 2, university: university)
      end

      before { get :index }

      it { expect(controller.disciplines).to match_array(disciplines) }
    end

    describe '#helper_methods' do
      let(:fields) { ['name', 'course_name'] }
      let(:path)   { 'views/admin/disciplines/index' }

      before { get :index }

      include_examples 'admin_fields_helper_method'
      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#pagination' do
      let(:per_page)             { Admin::DisciplinesController::PER_PAGE }
      let(:controller_resources) { controller.disciplines }
      let!(:resources) do
        create_list(:discipline, (per_page + 1), university: university)
          .sort! { |a,b| a.name <=> b.name }
      end

      before { get :index }

      include_examples 'admin_pagination'
    end

    describe '#search' do
      let!(:searched_discipline) do
        create(:discipline, name: 'searched_name', university: university)
      end

      let(:search) { '' }

      before do
        disciplines
        get :index, params: { search: search }
      end

      context 'empty search' do
        it do
          expect(controller.disciplines)
            .to match_array(disciplines.push(searched_discipline))
        end
      end

      context 'by name' do
        let(:search) { 'searched_name' }

        it { expect(controller.disciplines).to match_array([searched_discipline]) }
      end
    end

    describe '#filter' do
      let!(:courses) { create_list(:course, 2, university: university) }
      let!(:filtered_discipline) do
        create(:discipline, university: university, course: courses.first)
      end

      let(:filter) { { course: '' } }

      before do
        disciplines
        get :index, params: { filter: filter }
      end

      context 'empty filter' do
        it do
          expect(controller.disciplines)
            .to match_array(disciplines.push(filtered_discipline))
        end
      end

      context 'by course' do
        let(:filter) { { course: "#{courses.first.id}" } }

        it { expect(controller.disciplines).to match_array([filtered_discipline]) }
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
      it { expect(controller.discipline).to be_a_new(model) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/disciplines/new' }

      before { get :new }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_new_permission'
    end
  end

  describe '#create' do
    let(:valid_discipline)   { build(:discipline, university: university) }
    let(:invalid_discipline) { build(:discipline, :invalid ) }
    let(:valid_attributes)   { valid_discipline.attributes }
    let(:invalid_attributes) { invalid_discipline.attributes }
    let(:valid_params)       { { params: { discipline: valid_attributes } } }
    let(:invalid_params)     { { params: { discipline: invalid_attributes } } }

    context 'permitted params' do
      let(:model_symbol)  { :discipline }
      let(:action)        { :create }

      include_examples 'admin_permited_params'
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.disciplines.create.success') }

      include_examples 'admin_create_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.disciplines.create.error') }

      include_examples 'admin_create_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_create_permission'
    end
  end

  describe '#show' do
    let(:valid_params) { { params: { id: discipline } } }

    describe '#template' do
      let(:action) { :show }

      before { get :show, valid_params }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :show, valid_params }
      it { expect(controller.discipline).to eq(discipline) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/disciplines/show' }

      before { get :show, valid_params }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_show_permission'
    end
  end

  describe '#edit' do
    let(:valid_params) { { params: { id: discipline.id } } }

    describe '#template' do
      let(:action) { :edit }

      before { get :edit, valid_params }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :edit, valid_params }
      it { expect(controller.discipline).to eq(discipline) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/disciplines/edit' }

      before { get :edit, valid_params }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_edit_permission'
    end
  end

  describe '#update' do
    let(:valid_discipline) do
      build(:discipline, university: university,
        created_at: discipline.created_at)
    end
    let(:invalid_discipline) do
      build(:discipline, :invalid, university: university)
    end
    let(:valid_attributes)   { valid_discipline.attributes }
    let(:invalid_attributes) { invalid_discipline.attributes }
    let(:valid_params) do
      { params: { id: discipline.id, discipline: valid_attributes } }
    end
    let(:invalid_params) do
      { params: { id: discipline.id, discipline: invalid_attributes } }
    end

    context 'permitted params' do
      let(:model_symbol)  { :discipline }
      let(:action)        { :update }

      include_examples 'admin_permited_params'
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.disciplines.update.success') }

      include_examples 'admin_update_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.disciplines.update.error') }

      include_examples 'admin_update_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_update_permission'
    end
  end

  describe '#destroy' do
    let!(:discipline)    { create(:discipline) }
    let(:valid_params) { { params: { id: discipline.id } } }

    context 'always' do
      before { delete :destroy, valid_params }

      it { is_expected.to redirect_to action: :index }
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.disciplines.destroy.success') }

      include_examples 'admin_destroy_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.disciplines.destroy.error') }

      include_examples 'admin_destroy_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_destroy_permission'
    end
  end

end
