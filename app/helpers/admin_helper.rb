module AdminHelper

  def link_to_remove(path)
    tooltip_title   = t('tooltip_remove_action')
    attributes      = { confirm: t('destroy_confirmation') }
    data_attributes = link_data_attributes(tooltip_title, attributes)

    link(path, data_attributes, 'fa fa-trash-o', { method: 'delete' })
  end

  def link_to_edit(path)
    tooltip_title   = t('tooltip_edit_action')
    data_attributes = link_data_attributes(tooltip_title)

    link(path, data_attributes, 'fa fa-pencil-square-o')
  end

  private

  def tooltip_data_attribute(tooltip_title)
    { toggle: 'tooltip', title: tooltip_title }
  end

  def link_data_attributes(tooltip_title, attributes={})
    data_attributes = { data: {  } }
    data_attributes[:data].merge! tooltip_data_attribute(tooltip_title)
    data_attributes[:data].merge! attributes
    data_attributes
  end

  def link(path, data_attributes, content_tag_i_class, options={})
    p content_tag(:i, class: content_tag_i_class).html_safe

    link_to path, data_attributes, options do
      content_tag(:i, nil, class: content_tag_i_class).html_safe
    end
  end

end
