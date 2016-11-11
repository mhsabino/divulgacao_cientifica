class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # methods

  def current_university
    University.first
  end
end
