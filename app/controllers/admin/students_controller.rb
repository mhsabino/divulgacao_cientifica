class Admin::StudentsController < AdministratorController
  include Admin::BaseController
  include Admin::BreadcrumbController

  # before actions

  before_action :student_university,  only: :create
  before_action :student_role,        only: :create
  before_action :build_student_user,  only: :new

  # constants

  PER_PAGE = 10

  PERMITTED_PARAMS = [
    :name,
    :registration,
    :school_class_id,
    user_attributes: [:id, :email, :password, :password_confirmation]
  ]

  # exposures

  expose(:student, attributes: :student_params)
  expose(:students) { paginated_students }

  # methods

  private

  # finders

  def find_students
    Student.by_university(current_university)
  end

  def paginated_students
    ordered_students.page(params[:page]).per(PER_PAGE)
  end

  def searched_students
    find_students.search(params[:search])
  end

  def filtered_students
    filter_params = params.fetch(:filter, {})
    Student.filter_by(searched_students, filter_params)
  end

  def ordered_students
    filtered_students.order_by_name
  end

  # params

  def student_params
    params.require(:student).permit(*PERMITTED_PARAMS)
  end

  # helper methods

  def fields
    %w(name registration)
  end

  # base controller

  def resource
    student
  end

  def resource_params
    student_params
  end

  # setter methods

  def build_student_user
    student.build_user
  end

  def student_university
    student.university = current_university
  end

  def student_role
    build_student_user unless student.user.present?
    student.user.role = :student
  end
end
