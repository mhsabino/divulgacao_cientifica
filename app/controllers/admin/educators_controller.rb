class Admin::EducatorsController < AdministratorController

  before_action :authenticate_user!
  before_action :redirect_unauthorized_user

  # constants

  PERMITTED_PARAMS = [ :name, :registration, :course_id ]

  # exposes and helper methods

  expose(:educator, attributes: :educator_params)
  expose(:educators) { find_educators }

  helper_method [:fields]

  # actions

  def index
  end

  def new
  end

  def create
    if educator.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if educator.save
      redirect_to action: :show
    else
      render :edit
    end
  end

  # methods

  private

  def redirect_unauthorized_user
    redirect_to admin_root_path unless current_user.admin? || current_user.secretary?
  end

  def find_educators
    Educator.all
  end

  def educator_params
    params.require(:educator).permit(*PERMITTED_PARAMS)
  end

  def fields
    %w(registration name)
  end

end
