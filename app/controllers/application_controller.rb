class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  
  private
  #--------Redirect to user path after sign in----------#
  def after_sign_in_path_for(resource)
    current_user
  end

  #--------Redirect to root path after sign out---------#
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  #--------Redirect to home path after invitation accepted----------#
  # def after_accept_path_for(resource)
  #   home_path
  # end
end
