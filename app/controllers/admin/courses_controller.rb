class Admin::CoursesController < AdministratorController

  before_action :authenticate_user!
  before_action :redirect_unauthorized_user
  before_action :course_university, only: :create

  # constants

  PERMITTED_PARAMS = [ :name ]

  # exposes and helper methods

  expose(:course, attributes: :course_params)
  expose(:courses) { find_courses }

  helper_method [:fields, :javascript, :stylesheet]

  # actions

  def index
  end

  def new
  end

  def create
    if course.save
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
    if course.update(course_params)
      flash[:notice] = t('.success')
      redirect_to action: :show
    else
      flash[:alert] = t('.error')
      render :edit
    end
  end

  def destroy
    if course.destroy
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

  def find_courses
    Course.all
  end

  def course_params
    params.require(:course).permit(*PERMITTED_PARAMS)
  end

  # helper methods

  def javascript
    "views/#{controller_path}/#{action_name}"
  end

  def stylesheet
    "views/#{controller_path}/#{action_name}"
  end

  def fields
    %w(name)
  end

  # setter methods

  def course_university
    course.university = current_university
  end
end
