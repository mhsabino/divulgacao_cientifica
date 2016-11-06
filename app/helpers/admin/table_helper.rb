module Admin::TableHelper
  def display_admin_responsive_table(model, collection=[], fields=[])

    content_tag(:div, class: 'table-responsive') do
      table(model, collection, fields)
    end
  end

  private

  # table

  def table(model, collection, fields)
    table_head = table_head(model, fields)
    table_body = table_body(collection)

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

  def table_body(collection)
    content_tag(:tbody) { render collection }
  end
end
