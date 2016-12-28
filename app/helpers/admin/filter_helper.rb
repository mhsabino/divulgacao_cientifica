module Admin::FilterHelper

  def filter_by(f, field, collection=[], include_blank=nil, selected_value=nil)
    include_blank = I18n.t('select_option') unless include_blank
    filter_param  = params.fetch(:filter, {}).fetch(field, '')

    f.input field, collection: collection, label: false,
      input_html: { data: { filter: '' } },
      include_blank: include_blank,
      selected: selected(filter_param, selected_value)
  end

  private

  def selected(filter_param, custom_selected_value)
    filter_param.present? ? filter_param : custom_selected_value
  end

end
