module Admin::SchoolClasses::SchoolClassesHelper

  def can_remove_school_class?(school_class)
    return false unless school_class
    remove_school_class?(school_class)
  end

  def link_to_remove_school_class(school_class)
    if can_remove_school_class?(school_class)
      link_to_remove admin_school_class_path(school_class)
    else
      show_school_class_cannot_be_removed_tooltip_message(school_class)
    end
  end

  private

  def school_class_has_students?(school_class)
    school_class.students.present?
  end

  def remove_school_class?(school_class)
    !school_class_has_students?(school_class)
  end

  def show_school_class_cannot_be_removed_tooltip_message(school_class)
    content_tag(:i, nil, class: 'fa fa-trash-o fa-lg tip',
      data: { toggle: 'tooltip', title: school_class_tooltip_message(school_class) })
  end

  def school_class_tooltip_message(school_class)
    reason = pluralized_localized_model_name(Student)
    t('.school_class_cannot_be_removed', reason: reason)
  end
end
