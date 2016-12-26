module Admin::TableHelper
  def display_admin_responsive_table(model, collection=[], fields=[])

    content_tag(:div, class: 'table-responsive') do
      table(model, collection, fields)
    end
  end

  def link_to_remove(path)
    tooltip_title   = t('tooltip_remove_action')
    attributes      = { confirm: t('destroy_confirmation'), method: 'delete' }
    data_attributes = link_data_attributes(tooltip_title, attributes)

    link(path, data_attributes, 'fa fa-trash-o')
  end

  def link_to_edit(path)
    tooltip_title   = t('tooltip_edit_action')
    data_attributes = link_data_attributes(tooltip_title)

    link(path, data_attributes, 'fa fa-pencil-square-o')
  end

  private

  # links

  def tooltip_data_attribute(tooltip_title)
    { toggle: 'tooltip', title: tooltip_title }
  end

  def link_data_attributes(tooltip_title, attributes={})
    data_attributes = { data: {  } }
    data_attributes[:data].merge! tooltip_data_attribute(tooltip_title)
    data_attributes[:data].merge! attributes
    data_attributes
  end

  def link(path, data_attributes, content_tag_i_class)
    link_to path, data_attributes do
      content_tag(:i, nil, class: content_tag_i_class).html_safe
    end
  end

  # table

  def table(model, collection, fields)
    table_head = table_head(model, fields)
    table_body = table_body(collection, model, (fields.count + 1))

    content_tag(:table, class: 'table table-striped table-hover') do
      table_head.concat(table_body)
    end
  end

  # table head

  def table_head(model, fields)
    content_tag(:thead, tr_table_head(model, fields))
  end

  def tr_table_head(model, fields)
    content_tag(:tr) do
      th_table_head(model, fields)
    end
  end

  def th_table_head(model, fields)
    fields.each do |field|
      concat content_tag(:th, model.human_attribute_name(field))
    end

    concat content_tag(:th, I18n.t('actions'))
  end

  # table body

  def table_body(collection, model, fields_count)
    if collection.present?
      content_tag(:tbody) { render collection }
    else
      content_tag(:tbody) { collection_not_found(model, fields_count) }
    end
  end

  def collection_not_found(model, fields_count)
    content_tag(:tr) do
      content_tag(:td, class: 'alert alert-info text-center', colspan: fields_count) do
        I18n.t('register_not_found', resource: downcase_model_name(model))
      end
    end
  end
end
