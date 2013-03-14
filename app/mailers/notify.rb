class Notify < ActionMailer::Base
  default from: "support@bugtracker.com"

  def user_profile_update_notification(user)
  	@user = user
  	mail(:to => user.email, :subject => "Your changes have been saved.")
  end

  def ticket_creation_notification(user, project, ticket)
  	@user = user
  	@project = project
  	@ticket = ticket
  	mail(:to => @user.email, :subject => "A new ticket with title (#{@ticket.title}) has been created.")
  end

  def member_added_notification_to_admin(admin, project, user)
  	@admin = admin
  	@user = user
  	@project = project
  	mail(:to => @admin.email, :subject => "A member with email (#{@user.email}) has been added to project (#{@project.title}).")
  end

  def notification_to_member_that_added(admin, project, user)
	@admin = admin
  	@user = user
  	@project = project
  	mail(:to => @user.email, :subject => "You  are added by (#{@admin.email}) as member in project (#{@project.title}).")
  end

  def notify_to_whom_ticket_is_assigned(admin, project, ticket)
	@admin = admin
  	@project = project
  	@ticket = ticket
  	@user =	User.find_by_id(@ticket.assigned_to)
  	mail(:to => @user.email, :subject => "A ticket with title (#{@ticket.title}) has been assigned to you.")
  end
end
