class Admin::EducatorsController < AdministratorController
  include Admin::BaseController
  include Admin::BreadcrumbController

  # before actions

  before_action :educator_university,  only: :create
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
    ordered_educators.page(params[:page]).per(PER_PAGE)
  end

  def searched_educators
    find_educators.search(params[:search])
  end

  def filtered_educators
    filter_params = params.fetch(:filter, {})
    Educator.filter_by(searched_educators, filter_params)
  end

  def ordered_educators
    filtered_educators.order_by_name
  end

  # params

  def educator_params
    params.require(:educator).permit(*PERMITTED_PARAMS)
  end

  # helper methods

  def fields
    %w(name registration)
  end

  # base controller

  def resource
    educator
  end

  def resource_params
    educator_params
  end

  # setter methods

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
