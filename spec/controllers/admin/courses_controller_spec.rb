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
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

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

        it do
          expect(post :create, valid_params)
            .to redirect_to(admin_courses_path)
        end
        it do
          expect{ post :create, valid_params }
            .to change{ Course.count }.by(1)
        end
      end

      context 'when a admin user tries to access' do
        let(:role) { :admin }

        before do
          sign_out user
          sign_in other_user
        end

        it do
          expect(post :create, valid_params)
            .to redirect_to(admin_courses_path)
        end
        it do
          expect{ post :create, valid_params }
            .to change{ Course.count }.by(1)
        end
      end
    end
  end

  describe '#show' do
    describe '#template' do
      before { get :show, params: { id: course } }
      render_views

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :show }
    end

    describe '#exposes' do
      before { get :show, params: { id: course } }
      it { expect(controller.course).to eq(course) }
    end

    describe '#helper_methods' do
      describe 'javascript' do
        let(:expected_result) { "views/admin/courses/show" }
        before { get :show, params: { id: course } }

        it { expect(controller.send(:javascript)).to eq(expected_result) }
      end

      describe 'stylesheet' do
        let(:expected_result) { "views/admin/courses/show" }
        before { get :show, params: { id: course } }

        it { expect(controller.send(:stylesheet)).to eq(expected_result) }
      end
    end


    describe '#permissions' do
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

      before do
        sign_out user
        sign_in other_user
        get :show, params: { id: course }
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
      before { get :edit, params: { id: course } }
      render_views

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :edit }
    end

    describe '#exposes' do
      before { get :edit, params: { id: course } }
      it { expect(controller.course).to eq(course) }
    end

    describe '#helper_methods' do
      describe 'javascript' do
        let(:expected_result) { "views/admin/courses/edit" }
        before { get :edit, params: { id: course } }

        it { expect(controller.send(:javascript)).to eq(expected_result) }
      end

      describe 'stylesheet' do
        let(:expected_result) { "views/admin/courses/edit" }
        before { get :edit, params: { id: course } }

        it { expect(controller.send(:stylesheet)).to eq(expected_result) }
      end
    end

    describe '#permissions' do
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

      before do
        sign_out user
        sign_in other_user
        get :edit, params: { id: course }
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
    let(:valid_course) do
      build(:course, university: university, created_at: course.created_at)
    end
    let(:invalid_course) do
      build(:course, :invalid, university: university)
    end
    let(:valid_attributes)   { valid_course.attributes }
    let(:invalid_attributes) { invalid_course.attributes }
    let(:valid_params) do
      { params: { id: course, course: valid_attributes } }
    end
    let(:invalid_params) do
      { params: { id: course, course: invalid_attributes } }
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
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }
      let(:course_attributes) do
        valid_course.attributes.except('id', 'updated_at')
      end

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

      context 'when a secretary user tries to access' do
        before { course.reload }

        it { is_expected.to redirect_to admin_course_path(course) }
        it { expect(course).to have_attributes(course_attributes) }
      end

      context 'when a admin user tries to access' do
        let(:role) { :admin }

        before { course.reload }

        it { is_expected.to redirect_to admin_course_path(course) }
        it { expect(course).to have_attributes(course_attributes) }
      end
    end
  end

  describe '#destroy' do
    let!(:course) { create(:course) }

    context 'always' do
      before { delete :destroy, params: { id: course } }

      it { is_expected.to redirect_to action: :index }
    end

    context 'with valid params' do
      it do
        expect{ delete :destroy, params: { id: course } }
          .to change{ Course.count }.by(-1)
      end

      context 'shows flash' do
        let(:expected_flash) { I18n.t('admin.courses.destroy.success') }

        before { delete :destroy, params: { id: course } }

        it { expect(controller).to set_flash[:notice].to(expected_flash) }
      end
    end

    context 'with invalid params' do
      before do
        allow_any_instance_of(Course).to receive(:destroy).and_return(false)
      end

      it do
        expect{ delete :destroy, params: { id: course } }
          .not_to change{ Course.count }
      end

      context 'shows flash' do
        let(:expected_flash) { I18n.t('admin.courses.destroy.error') }

        before { delete :destroy, params: { id: course } }

        it { expect(controller).to set_flash[:alert].to(expected_flash) }
      end
    end

    describe '#permissions' do
      let(:role)       { :secretary }
      let(:other_user) { create(:user, role: role) }

      before do
        sign_out user
        sign_in other_user
        delete :destroy, params: { id: course }
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
        it { is_expected.to redirect_to admin_courses_path }
        it do
          expect{ Course.find(course.id) }
            .to raise_exception{ ActiveRecord::RecordNotFound }
        end
      end

      context 'when a admin user tries to access' do
        let(:role) { :admin }

        it { is_expected.to redirect_to admin_courses_path }
        it do
          expect{ Course.find(course.id) }
            .to raise_exception{ ActiveRecord::RecordNotFound }
        end
      end
    end
  end

end
