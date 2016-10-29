require 'rails_helper'

RSpec.describe Admin::HomeController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#index' do
    describe 'template' do
      before { get :index }
      render_views

      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :index }
    end

    describe 'permissions' do
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
        let(:role) { :admin }
        it { is_expected.to render_template :index }
      end
    end
  end

end
