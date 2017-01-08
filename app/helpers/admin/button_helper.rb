module Admin::ButtonHelper

  def new_resource_button(path, button_text='')
    link_to button_text, path, class: 'btn btn-primary btn-block', role: "button"
  end

  def save_button(form)
    form.button :submit, class: 'btn btn-primary pull-right'
  end

end
