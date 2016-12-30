require 'rails_helper'

RSpec.describe Admin::StudentsController, type: :controller do
  let(:model)      { Student }
  let(:user)       { create(:user) }
  let(:university) { create(:university) }
  let(:student)    { students.first }
  let(:permitted_params) do
    [
      :name,
      :registration,
      :school_class_id,
      user_attributes: [:id, :email, :password, :password_confirmation]
    ]
  end
  let(:students) do
    create_list(:student, 2, user: create(:user, :student),
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
      let!(:other_student) { create(:student) }
      let!(:students) do
        create_list(:student, 2, user: create(:user, :student),
          university: university)
      end

      before { get :index }

      it { expect(controller.students).to match_array(students) }
    end

    describe '#helper_methods' do
      let(:fields) { ['name', 'registration'] }
      let(:path)   { 'views/admin/students/index' }

      before { get :index }

      include_examples 'admin_fields_helper_method'
      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#pagination' do
      let(:per_page)             { Admin::StudentsController::PER_PAGE }
      let(:controller_resources) { controller.students }
      let!(:resources) do
        create_list(:student, (per_page + 1), university: university)
          .sort! { |a,b| a.name <=> b.name }
      end

      before { get :index }

      include_examples 'admin_pagination'
    end

    describe '#search' do
      let!(:searched_student) do
        create(:student, name: 'searched_name',
          registration: 'searched_registration', university: university)
      end

      let(:search) { '' }

      before do
        students
        get :index, params: { search: search }
      end

      context 'empty search' do
        it do
          expect(controller.students)
            .to match_array(students.push(searched_student))
        end
      end

      context 'by name' do
        let(:search) { 'searched_name' }

        it { expect(controller.students).to match_array([searched_student]) }
      end

      context 'by registration' do
        let(:search) { 'searched_registration' }

        it { expect(controller.students).to match_array([searched_student]) }
      end
    end

    describe '#filter' do
      let!(:school_classes) do
        create_list(:school_class, 2, university: university)
      end
      let!(:filtered_student) do
        create(:student, university: university,
          school_class: school_classes.first)
      end

      let(:filter) { { school_class: '' } }

      before do
        students
        get :index, params: { filter: filter }
      end

      context 'empty filter' do
        it do
          expect(controller.students)
            .to match_array(students.push(filtered_student))
        end
      end

      context 'by school_class' do
        let(:filter) { { school_class: "#{school_classes.first.id}" } }

        it { expect(controller.students).to match_array([filtered_student]) }
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
      it { expect(controller.student).to be_a_new(model) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/students/new' }

      before { get :new }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_new_permission'
    end
  end

  describe '#create' do
    let(:valid_student)   { build(:student, university: university) }
    let(:invalid_student) { build(:student, :invalid ) }
    let(:valid_attributes) do
      valid_student.attributes
        .merge!({ user_attributes: build(:user).attributes
          .merge!({ password: 'letmein' }) })
    end
    let(:invalid_attributes) do
      invalid_student.attributes
        .merge!({ user_attributes: build(:user).attributes })
    end
    let(:valid_params)   { { params: { student: valid_attributes } } }
    let(:invalid_params) { { params: { student: invalid_attributes } } }

    context 'permitted params' do
      let(:model_symbol)  { :student }
      let(:action)        { :create }

      include_examples 'admin_permited_params'
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.students.create.success') }

      include_examples 'admin_create_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.students.create.error') }

      include_examples 'admin_create_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_create_permission'
    end
  end

  describe '#show' do
    let(:valid_params) { { params: { id: student } } }

    describe '#template' do
      let(:action) { :show }

      before { get :show, valid_params }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :show, valid_params }
      it { expect(controller.student).to eq(student) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/students/show' }

      before { get :show, valid_params }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_show_permission'
    end
  end

  describe '#edit' do
    let(:valid_params) { { params: { id: student.id } } }

    describe '#template' do
      let(:action) { :edit }

      before { get :edit, valid_params }

      include_examples 'admin_templates'
    end

    describe '#exposes' do
      before { get :edit, valid_params }
      it { expect(controller.student).to eq(student) }
    end

    describe '#helper_methods' do
      let(:path) { 'views/admin/students/edit' }

      before { get :edit, valid_params }

      include_examples 'admin_javascript_helper_method'
      include_examples 'admin_stylesheet_helper_method'
    end

    describe '#permissions' do
      include_examples 'admin_edit_permission'
    end
  end

  describe '#update' do
    let(:valid_student) do
      build(:student, user: student.user, university: university,
        created_at: student.created_at)
    end
    let(:invalid_student) do
      build(:student, :invalid, user: user, university: university)
    end
    let(:valid_attributes)   { valid_student.attributes }
    let(:invalid_attributes) { invalid_student.attributes }
    let(:valid_params) do
      { params: { id: student.id, student: valid_attributes } }
    end
    let(:invalid_params) do
      { params: { id: student.id, student: invalid_attributes } }
    end

    context 'permitted params' do
      let(:model_symbol)  { :student }
      let(:action)        { :update }

      include_examples 'admin_permited_params'
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.students.update.success') }

      include_examples 'admin_update_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.students.update.error') }

      include_examples 'admin_update_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_update_permission'
    end
  end

  describe '#destroy' do
    let!(:student)     { create(:student) }
    let(:valid_params) { { params: { id: student.id } } }

    context 'always' do
      before { delete :destroy, valid_params }

      it { is_expected.to redirect_to action: :index }
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.students.destroy.success') }

      include_examples 'admin_destroy_valid_params'
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.students.destroy.error') }

      include_examples 'admin_destroy_invalid_params'
    end

    describe '#permissions' do
      include_examples 'admin_destroy_permission'
    end
  end

end
