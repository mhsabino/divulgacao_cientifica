module Admin::BaseController
  extend ActiveSupport::Concern

  # constants

  DEFAULT_HELPER_METHODS = [:fields, :javascript, :stylesheet]

  included do

    # helper methods

    helper_method DEFAULT_HELPER_METHODS

    # actions

    def create
      if resource.save
        redirect_to_index_with_success
      else
        render_new_with_error
      end
    end

    def update
      if resource.update(resource_params)
        redirect_to_show_with_success
      else
        render_edit_with_error
      end
    end

    def destroy
      if resource.destroy
        redirect_to_index_with_success
      else
        redirect_to_index_with_error
      end
    end

    # methods

    private

    # redirects and renders

    def redirect_to_index_with_success
      flash[:notice] = t('.success')
      redirect_to action: :index
    end

    def render_new_with_error
      flash[:alert] = t('.error')
      render :new
    end

    def redirect_to_show_with_success
      flash[:notice] = t('.success')
      redirect_to action: :show
    end

    def render_edit_with_error
      flash[:alert] = t('.error')
      render :edit
    end

    def redirect_to_index_with_error
      flash[:alert] = t('.error')
      redirect_to action: :index
    end

    # permissions

    def redirect_unauthorized_user
      unless current_user.admin? || current_user.secretary?
        redirect_to admin_root_path
      end
    end

    # helper methods

    def javascript
      "views/#{controller_path}/#{action_name}"
    end

    def stylesheet
      "views/#{controller_path}/#{action_name}"
    end
  end

end
