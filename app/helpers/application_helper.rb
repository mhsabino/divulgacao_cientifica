module ApplicationHelper
  def downcase_model_name(model=nil)
    model.model_name.human.downcase if model.present?
  end

  def flash_message
    message = ''

    [:notice, :info, :warning, :alert].each do |type|
      message += "<div class='#{flash_style(type)}'>#{flash[type]}</div>" if flash[type]
    end

    message.html_safe
  end

  def current_year
    Date.today.year
  end

  private

  def flash_style(flash_type)
    return 'alert alert-success' if flash_type == :notice
    return 'alert alert-info'    if flash_type == :info
    return 'alert alert-warning' if flash_type == :warning
    return 'alert alert-danger'  if flash_type == :alert
  end
end
