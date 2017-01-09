module Admin::Courses::CoursesHelper

  def can_remove_course?(course)
    return false unless course
    !course.school_classes.present? && !course.educators.present? && !course.disciplines.present?
  end

  def link_to_remove_course(course)
    if can_remove_course?(course)
      link_to_remove admin_course_path(course)
    else
      content_tag(:i, nil, class: 'fa fa-trash-o fa-lg tip',
        data: { toggle: 'tooltip', title: 'Não pode ser removido pois existem associaçẽos a esse curso' })
    end
  end

end
