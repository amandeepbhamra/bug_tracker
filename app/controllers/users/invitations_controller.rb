class Users::InvitationsController < Devise::InvitationsController

  before_filter :authenticate_inviter!, :only => [:new, :create]
  before_filter :has_invitations_left?, :only => [:create]
  before_filter :require_no_authentication, :only => [:edit, :update]
  helper_method :after_sign_in_path_for
  before_filter :validate_user, :only => [:new]
  
  after_filter  :create_invitation_reference, :only => [:update]


  # GET /resource/invitation/new
  def new
    # debugger
    @new_user = User.new

    # build_resource
    # render :new
  end

  # POST /resource/invitation
  def create
    @user = User.find_by_email(resource_params[:email])
    if @user.nil?
      @project = params[:project]
      self.resource = resource_class.invite!({:email => resource_params[:email], :invited_for_project_id => params[:project]},current_inviter)
      if resource.errors.empty?
        set_flash_message :notice, :send_instructions, :email => self.resource.email
        redirect_to current_inviter
      else
        respond_with_navigational(resource) { render :new }
      end
    else
      @already_invited = Invitation.where(:invited_by_id => current_inviter.id, :user_id => @user.id)
      @assigned_project = @user.assigned_projects.where("project_id = ?", params[:project])
      @user_invited = User.find_by_email(resource_params[:email])
      if  @already_invited.blank? and @assigned_project.blank?
          Invitation.create(:invited_by_id => current_inviter.id, :user_id => @user.id)
          @project = Project.find_by_id(params[:project])
          resource.assigned_projects = [@project]
          @user = User.find_by_id(current_inviter.id)
          @user.invited_by_id = nil
          @user.save
          Notify.notification_to_member_that_added(@user, @project, @user_invited ).deliver
          redirect_to current_inviter, notice: "User is added in the project"
      else
        @project = Project.find_by_id(params[:project])
        resource.assigned_projects = [@project]
        @user = User.find_by_id(current_inviter.id)
        Notify.notification_to_member_that_added(@user, @project, @user_invited ).deliver
        redirect_to current_inviter, notice: "User already invited by you, But now is added in the project"
      end
    end
  end

  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    if params[:invitation_token] && self.resource = resource_class.to_adapter.find_first( :invitation_token => params[:invitation_token] )
      render :edit
    else
      set_flash_message(:alert, :invitation_token_invalid)
      redirect_to after_sign_out_path_for(resource_name)
    end
  end

  # PUT /resource/invitation
  def update
    self.resource = resource_class.accept_invitation!(resource_params)

    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active                                                                                        
      set_flash_message :notice, flash_message
      sign_in(resource_name, resource)

      redirect_to current_inviter
    else
      respond_with_navigational(resource){ render :edit }
    end
  end

  protected
  
  # Filter To check whether user exits or not #
  def validate_user 
    @user = current_inviter
  end
  
  def current_inviter
    @current_inviter ||= authenticate_inviter!
  end

  def has_invitations_left?
    unless current_inviter.nil? || current_inviter.has_invitations_left?
      build_resource
      set_flash_message :alert, :no_invitations_remaining
      respond_with_navigational(resource) { render :new }
    end
  end

  # After invitation accepted invitation reference will be made#
  def create_invitation_reference
    Invitation.create(:invited_by_id => resource.invited_by_id, :user_id => resource.id)
    @project = Project.find_by_id(resource.invited_for_project_id)
    resource.assigned_projects = [@project]
    @user = User.find_by_id(resource.invited_by_id)
    Notify.notification_to_member_that_added(resource, @project, @user ).deliver
    resource.invited_by_id = nil
    resource.invited_for_project_id = nil
    resource.save
  end
end
