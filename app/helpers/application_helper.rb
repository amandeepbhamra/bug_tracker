module ApplicationHelper
	
  # For displaying age of the ticket #
  def event_time_format(time)
  		now = Time.now
  		if now - time > 7.days
    		l(time, :format => :short)
  		else
    		distance_of_time_in_words(time, now, true) + ' ago'
  		end
	end
	
  # For removing fields dynamically generated #
	def link_to_remove_fields(name, f)
  		f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
	end

  # For generating fields dynamically #
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  # For just getting project title #
  def project_title(project)
    Project.project_title(project)
  end

  # For just getting user's name #
  def user_name(user)
    User.user_name(user)
  end

  # For just getting user's id #
  def user_id(user)
    User.user_id(user)
  end

  # For just getting user #
  def user(user)
    User.user(user)
  end

  # For getting open tickets count #
  def total_open_tickets(project,user)
    Project.open_tickets_count(project,user)
  end
end
