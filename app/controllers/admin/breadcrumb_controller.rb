module Admin::BreadcrumbController
  extend ActiveSupport::Concern

  included do

    before_action :add_breadcrumb_homepage
    before_action :add_breadcrumb_to_action_index
    before_action :add_breadcrumb_to_action_new,  only: [:new, :create]
    before_action :add_breadcrumb_to_action_edit, only: [:edit, :update]
    before_action :add_breadcrumb_to_action_show, only: :show

    private

    def add_breadcrumb_to_action_new
      add_breadcrumb I18n.t('breadcrumbs.new', resource: resource_downcase)
    end

    def add_breadcrumb_to_action_edit
      add_breadcrumb I18n.t('breadcrumbs.edit', resource: resource_downcase)
    end

    def add_breadcrumb_to_action_show
      add_breadcrumb resource.name
    end

    def add_breadcrumb_homepage
      add_breadcrumb I18n.t('homepage'), :admin_root_path
    end

    def add_breadcrumb_to_action_index
      add_breadcrumb resource_model_name(2), index_path
    end

    def resource_model_name(count=1)
      resource.model_name.human(count: count)
    end

    def resource_downcase
      resource_model_name.downcase
    end

    def resource_plural
      resource.model_name.plural
    end

    def index_path
      url_for(controller: "#{resource_plural}", action: 'index', only_path: true)
    end
  end

end
