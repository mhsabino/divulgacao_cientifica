class Admin::CoursesController < AdministratorController
  add_breadcrumb Course.model_name.human(count: 2), :admin_courses_path

  include Admin::BaseController
  include Admin::BreadcrumbController

  before_action :course_university, only: :create

  # constants

  PER_PAGE = 10

  PERMITTED_PARAMS = [ :name ]

  # exposures

  expose(:course, attributes: :course_params)
  expose(:courses) { paginated_courses }

  # methods

  private

  # finders

  def find_courses
    Course.by_university(current_university)
  end

  def paginated_courses
    searched_courses.page(params[:page]).per(PER_PAGE)
  end

  def searched_courses
    find_courses.search(find_courses, params[:search])
  end

  # params

  def course_params
    params.require(:course).permit(*PERMITTED_PARAMS)
  end

  # helper methods

  def fields
    %w(name)
  end

  # base controller

  def resource
    course
  end

  def resource_params
    course_params
  end

  # setter methods

  def course_university
    course.university = current_university
  end
end
