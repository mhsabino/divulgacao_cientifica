module ModelNameHelper
  def downcase_localized_model_name(model=nil)
    model.model_name.human.downcase if model.present?
  end

  def pluralized_string_model_name(string=nil)
    string.underscore.downcase.pluralize if string.present?
  end

  def constantized_string_model_name(string=nil)
    string.singularize.constantize if string.present?
  end

  def pluralized_localized_model_name(model=nil)
    model.model_name.human(count: 2) if model.present?
  end
end
