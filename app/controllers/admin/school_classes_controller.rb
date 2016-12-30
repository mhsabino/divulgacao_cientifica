class Admin::SchoolClassesController < AdministratorController
  include Admin::BaseController
  include Admin::BreadcrumbController

  # before actions

  before_action :school_class_university, only: :create

  # constants

  PER_PAGE = 10

  PERMITTED_PARAMS = [
    :course_id,
    :year,
    :period,
    :vacancies,
    :name,
    :course_id,
    student_attributes: [:id, :name, :registration]
  ]

  # exposures

  expose(:school_class, attributes: :school_class_params)
  expose(:school_classes) { paginated_school_classes }

  # methods

  private

  # finders

  def find_school_classes
    SchoolClass.by_university(current_university)
  end

  def paginated_school_classes
    ordered_school_classes.page(params[:page]).per(PER_PAGE)
  end

  def searched_school_classes
    find_school_classes.search(params[:search])
  end

  def filtered_school_classes
    SchoolClass.filter_by(searched_school_classes, custom_filter_params)
  end

  def ordered_school_classes
    filtered_school_classes.order_by_name
  end

  # params

  def school_class_params
    params.require(:school_class).permit(*PERMITTED_PARAMS)
  end

  # helper methods

  def fields
    %w(name course_name year vacancies period)
  end

  # base controller

  def resource
    school_class
  end

  def resource_params
    school_class_params
  end

  # setters

  def school_class_university
    school_class.university = current_university
  end

  def custom_filter_params
    filter_params = params.fetch(:filter, {})
    year_param    = filter_params.fetch(:year, '')

    return filter_params if year_param.present?
    filter_params.merge!( { year: DateTime.now.year } )
  end
end
