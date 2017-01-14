module Admin::Courses::CoursesHelper

  def can_remove_course?(course)
    return false unless course
    remove_course?(course)
  end

  def link_to_remove_course(course)
    if can_remove_course?(course)
      link_to_remove admin_course_path(course)
    else
      show_course_cannot_be_removed_tooltip_message(course)
    end
  end

  private

  def course_has_school_classes?(course)
    course.school_classes.present?
  end

  def course_has_educators?(course)
    course.educators.present?
  end

  def course_has_disciplines?(course)
    course.disciplines.present?
  end

  def remove_course?(course)
    !course_has_school_classes?(course) &&
    !course_has_educators?(course) &&
    !course_has_disciplines?(course)
  end

  def show_course_cannot_be_removed_tooltip_message(course)
    content_tag(:i, nil, class: 'fa fa-trash-o fa-lg tip',
      data: { toggle: 'tooltip', title: course_tooltip_message(course) })
  end

  def course_tooltip_message(course)
    message = []
    message << pluralized_localized_model_name(SchoolClass) if course_has_school_classes?(course)
    message << pluralized_localized_model_name(Educator)    if course_has_educators?(course)
    message << pluralized_localized_model_name(Discipline)  if course_has_disciplines?(course)
    reason = message.to_sentence(locale: 'pt-BR')

    t('.course_cannot_be_removed', reason: reason)
  end

end
