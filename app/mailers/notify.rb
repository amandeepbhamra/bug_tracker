class Notify < ActionMailer::Base
  default from: "support@lighthouseapp.com"

  def user_profile_update_notification(user)
  	mail(:to => user.email, :subject => "Your changes have been saved.")
  end

  def ticket_creation_notification(user, project, ticket)
  	@user = user
  	@project = project
  	@ticket = ticket
  	mail(:to => @user.email, :subject => "A new ticket title (#{@ticket.title}) has been created.")
  end
end
