class Admin::DisciplinesController < AdministratorController
  include Admin::BaseController
  include Admin::BreadcrumbController

  # before actions

  before_action :discipline_university, only: :create

  # constants

  PER_PAGE = 10

  PERMITTED_PARAMS = [
    :name,
    :course_id,
    :description
  ]

  # exposures

  expose(:discipline, attributes: :discipline_params)
  expose(:disciplines) { paginated_disciplines }

  # methods

  private

  # finders

  def find_disciplines
    Discipline.by_university(current_university)
  end

  def paginated_disciplines
    ordered_disciplines.page(params[:page]).per(PER_PAGE)
  end

  def searched_disciplines
    find_disciplines.search(params[:search])
  end

  def filtered_disciplines
    filter_params = params.fetch(:filter, {})
    Discipline.filter_by(searched_disciplines, filter_params)
  end

  def ordered_disciplines
    filtered_disciplines.order_by_name
  end

  # params

  def discipline_params
    params.require(:discipline).permit(*PERMITTED_PARAMS)
  end

  # helper methods

  def fields
    %w(name course_name)
  end

  # base controller

  def resource
    discipline
  end

  def resource_params
    discipline_params
  end

  # setter methods

  def discipline_university
    discipline.university = current_university
  end
end
