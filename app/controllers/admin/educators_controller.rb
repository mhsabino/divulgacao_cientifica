class Admin::EducatorsController < AdministratorController
  add_breadcrumb Educator.model_name.human(count: 2), :admin_educators_path

  include Admin::BaseController
  include Admin::BreadcrumbController

  # before actions

  before_action :educator_university,  only: :create
  before_action :educator_course,      only: :create
  before_action :educator_role,        only: :create
  before_action :build_educator_user,  only: :new

  # constants

  PER_PAGE = 10

  PERMITTED_PARAMS = [
    :name,
    :registration,
    :course_id,
    user_attributes: [:id, :email, :password, :password_confirmation]
  ]

  # exposures

  expose(:educator, attributes: :educator_params)
  expose(:educators) { paginated_educators }

  # methods

  private

  # finders

  def find_educators
    Educator.by_university(current_university)
  end

  def paginated_educators
    filtered_educators.page(params[:page]).per(PER_PAGE)
  end

  def searched_educators
    find_educators.search(find_educators, params[:search])
  end

  def filtered_educators
    result        = searched_educators
    filter_params = params.fetch(:filter, {})

    return result unless filter_params.present?

    course_filter = filter_params.fetch(:course, '')

    result = result.by_course(course_filter) if course_filter.present?
    result
  end

  # params

  def educator_params
    params.require(:educator).permit(*PERMITTED_PARAMS)
  end

  # helper methods

  def fields
    %w(registration name)
  end

  # base controller

  def resource
    educator
  end

  def resource_params
    educator_params
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
