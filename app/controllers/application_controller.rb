class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  
  private
  #--------Redirect to user path after sign in----------#
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  #--------Redirect to root path after sign out---------#
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
