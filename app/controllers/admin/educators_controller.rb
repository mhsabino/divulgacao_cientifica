class Admin::EducatorsController < AdministratorController
  include Admin::BaseController

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

  # exposures

  expose(:educator, attributes: :educator_params)
  expose(:educators) { find_educators }

  # methods

  private

  # finders

  def find_educators
    Educator.all
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
