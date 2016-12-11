class AdministratorController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unauthorized_user

  layout 'admin'
end
