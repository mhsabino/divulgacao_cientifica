class Admin::HomeController < AdministratorController

  before_action :authenticate_user!
  before_action :redirect_unauthorized_user

  # actions

  def index
  end

  # methods

  private

  def redirect_unauthorized_user
    redirect_to admin_root_path unless current_user.admin? || current_user.secretary?
  end
end
