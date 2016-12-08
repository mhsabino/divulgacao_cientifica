class Admin::EducatorsController < AdministratorController

  before_action :authenticate_user!
  before_action :redirect_unauthorized_user
  before_action :educator_university, only: :create
  before_action :educator_course, only: :create
  before_action :build_educator_user, only: :new
  before_action :educator_role, only: :create

  # constants

  PERMITTED_PARAMS = [
    :name,
    :registration,
    :course_id,
    user_attributes: [:id, :email, :password, :password_confirmation]
  ]

  # exposes and helper methods

  expose(:educator, attributes: :educator_params)
  expose(:educators) { find_educators }

  helper_method [:fields, :javascript, :stylesheet]

  # actions

  def index
  end

  def new
  end

  def create
    if educator.save
      flash[:notice] = t('.success')
      redirect_to action: :index
    else
      flash[:alert] = t('.error')
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if educator.update(educator_params)
      flash[:notice] = t('.success')
      redirect_to action: :show
    else
      flash[:alert] = t('.error')
      render :edit
    end
  end

  def destroy
    if educator.destroy
      flash[:notice] = t('.success')
    else
      flash[:alert] = t('.error')
    end

    redirect_to action: :index
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

  # helper methods

  def javascript
    "views/#{controller_path}/#{action_name}"
  end

  def stylesheet
    "views/#{controller_path}/#{action_name}"
  end

  def fields
    %w(registration name)
  end

  # setter methods

  # TODO: Remove this after set the course
  def educator_course
    educator.course = Course.first
  end

  def build_educator_user
    educator.build_user
  end

  def educator_university
    educator.university = current_university
  end

  def educator_role
    build_educator_user unless educator.user.present?
    educator.user.role = :educator
  end
end
