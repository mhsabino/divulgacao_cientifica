module Admin::BreadcrumbController
  extend ActiveSupport::Concern

  included do

    before_action :add_breadcrumb_to_action_new,  only: [:new, :create]
    before_action :add_breadcrumb_to_action_edit, only: [:edit, :update]
    before_action :add_breadcrumb_to_action_show, only: :show

    private

    def add_breadcrumb_to_action_new
      add_breadcrumb I18n.t('breadcrumbs.new', resource: downcase_model_name)
    end

    def add_breadcrumb_to_action_edit
      add_breadcrumb I18n.t('breadcrumbs.edit', resource: downcase_model_name)
    end

    def add_breadcrumb_to_action_show
      add_breadcrumb resource.name
    end

    def downcase_model_name
      resource.model_name.human.downcase
    end
  end

end
