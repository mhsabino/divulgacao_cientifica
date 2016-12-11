class Admin::CoursesController < AdministratorController
  include Admin::BaseController

  before_action :course_university, only: :create

  # constants

  PERMITTED_PARAMS = [ :name ]

  # exposures

  expose(:course, attributes: :course_params)
  expose(:courses) { find_courses }

  # methods

  private

  # finders

  def find_courses
    Course.all
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
