require 'rails_helper'

RSpec.describe Admin::CoursesController, type: :controller do
  let(:user)             { create(:user) }
  let(:university)       { create(:university) }
  let(:course)           { courses.first }
  let(:permitted_params) { [ :name ] }
  let(:courses)          { create_list(:course, 2, university: university) }

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
      it { expect(controller.courses).to match_array(courses) }
    end

    describe '#helper_methods' do
      describe 'fields' do
        let(:expected_result) { ['name'] }

        it 'fields' do
          expect(controller.send(:fields)).to eq(expected_result)
        end
      end

      describe 'javascript' do
        let(:expected_result) { "views/admin/courses/index" }
        before { get :index }

        it { expect(controller.send(:javascript)).to eq(expected_result) }
      end

      describe 'stylesheet' do
        let(:expected_result) { "views/admin/courses/index" }
        before { get :index }

        it { expect(controller.send(:stylesheet)).to eq(expected_result) }
      end
    end

    describe '#permissions' do
      include_examples 'admin_index_permission'
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
      it { expect(controller.course).to be_a_new(Course) }
    end

    describe '#helper_methods' do
      describe 'javascript' do
        let(:expected_result) { "views/admin/courses/new" }
        before { get :new }

        it { expect(controller.send(:javascript)).to eq(expected_result) }
      end

      describe 'stylesheet' do
        let(:expected_result) { "views/admin/courses/new" }
        before { get :new }

        it { expect(controller.send(:stylesheet)).to eq(expected_result) }
      end
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
      it do
        is_expected.to permit(*permitted_params)
          .for(:create, params: valid_params).on(:course)
      end
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.courses.create.success') }

      before { post :create, valid_params }

      it { is_expected.to redirect_to action: :index }
      it { expect(controller).to set_flash[:notice].to(expected_flash) }
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.courses.create.error') }

      before { post :create, invalid_params }

      it { is_expected.to render_template :new }
      it { expect(controller).to set_flash[:alert].to(expected_flash) }
    end

    describe '#permissions' do
      include_examples 'admin_create_permission', Course
    end
  end

  describe '#show' do
    let(:valid_params) { { params: { id: course.id } } }

    describe '#template' do
      before { get :show, valid_params }
      render_views

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :show }
    end

    describe '#exposes' do
      before { get :show, valid_params }
      it { expect(controller.course).to eq(course) }
    end

    describe '#helper_methods' do
      describe 'javascript' do
        let(:expected_result) { "views/admin/courses/show" }
        before { get :show, valid_params }

        it { expect(controller.send(:javascript)).to eq(expected_result) }
      end

      describe 'stylesheet' do
        let(:expected_result) { "views/admin/courses/show" }
        before { get :show, valid_params }

        it { expect(controller.send(:stylesheet)).to eq(expected_result) }
      end
    end

    describe '#permissions' do
      include_examples 'admin_show_permission'
    end
  end

  describe '#edit' do
    let(:valid_params) { { params: { id: course.id } } }

    describe '#template' do
      before { get :edit, params: { id: course.id } }
      render_views

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :edit }
    end

    describe '#exposes' do
      before { get :edit, valid_params }
      it { expect(controller.course).to eq(course) }
    end

    describe '#helper_methods' do
      describe 'javascript' do
        let(:expected_result) { "views/admin/courses/edit" }
        before { get :edit, valid_params }

        it { expect(controller.send(:javascript)).to eq(expected_result) }
      end

      describe 'stylesheet' do
        let(:expected_result) { "views/admin/courses/edit" }
        before { get :edit, valid_params }

        it { expect(controller.send(:stylesheet)).to eq(expected_result) }
      end
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
      it do
        is_expected.to permit(*permitted_params)
          .for(:update, valid_params).on(:course)
      end
    end

    context 'with valid params' do
      let(:expected_flash) { I18n.t('admin.courses.update.success') }

      before { patch :update, valid_params }

      it { is_expected.to redirect_to action: :show }
      it { expect(controller).to set_flash[:notice].to(expected_flash) }
    end

    context 'with invalid params' do
      let(:expected_flash) { I18n.t('admin.courses.update.error') }

      before { patch :update, invalid_params }

      it { is_expected.to render_template :edit }
      it { expect(controller).to set_flash[:alert].to(expected_flash) }
    end

    describe '#permissions' do
      include_examples 'admin_update_permission', Course
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
      it do
        expect{ delete :destroy, valid_params }
          .to change{ Course.count }.by(-1)
      end

      context 'shows flash' do
        let(:expected_flash) { I18n.t('admin.courses.destroy.success') }

        before { delete :destroy, valid_params }

        it { expect(controller).to set_flash[:notice].to(expected_flash) }
      end
    end

    context 'with invalid params' do
      before do
        allow_any_instance_of(Course).to receive(:destroy).and_return(false)
      end

      it do
        expect{ delete :destroy, valid_params }
          .not_to change{ Course.count }
      end

      context 'shows flash' do
        let(:expected_flash) { I18n.t('admin.courses.destroy.error') }

        before { delete :destroy, valid_params }

        it { expect(controller).to set_flash[:alert].to(expected_flash) }
      end
    end

    describe '#permissions' do
      include_examples 'admin_destroy_permission', Course
    end
  end

end
