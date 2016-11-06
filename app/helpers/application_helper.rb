module ApplicationHelper
  def downcase_model_name(model=nil)
    return '' unless model.present?
    model.model_name.human.downcase
  end
end
