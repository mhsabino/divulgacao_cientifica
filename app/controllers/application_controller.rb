class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method [:current_university]

  # methods

  def current_university
    University.first
  end
end
