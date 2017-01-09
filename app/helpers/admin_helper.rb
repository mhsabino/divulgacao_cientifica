module AdminHelper

  def render_header_description(description)
    render 'admin/shared/header_description', description_text: description
  end

  def render_breadcrumb
    render 'admin/shared/breadcrumb'
  end
end
