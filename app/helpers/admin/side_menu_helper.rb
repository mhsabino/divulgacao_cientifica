module Admin::SideMenuHelper

  CONTROLLERS = [
    'Educator',
    'Student',
    'Course',
    'Discipline',
    'SchoolClass'
  ]

  def sorted_admin_controllers
    CONTROLLERS.sort! do |a,b|
      constantized_string_model_name(a).model_name.human <=>
      constantized_string_model_name(b).model_name.human
    end
  end

  def side_menu
    side_menu_ul = content_tag(:ul, side_menu_li)
    content_tag(:div, side_menu_ul, id: 'sidemenu')
  end

  private

  def side_menu_li
    sorted_admin_controllers.collect do |controller|
      content_tag(:li, side_menu_link(controller))
    end.join.html_safe
  end

  def side_menu_link(controller)
    constantized_model = constantized_string_model_name(controller)
    pluralized_model   = pluralized_localized_model_name(constantized_model)

    link_to pluralized_model, controller_path(controller), class: active_link(controller)
  end

  def pluralized_controller_name(controller)
    pluralized_string_model_name(controller)
  end

  def active_link(controller)
    'active_link' if controller_name == pluralized_string_model_name(controller)
  end

  def controller_path(controller)
    url_for(action: 'index', controller: pluralized_controller_name(controller))
  end
end
