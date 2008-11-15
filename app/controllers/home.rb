class Home < Application

  def index
  	# TODO: list in the order of last activity- join with snapshots
  	
 		if session.user
 		    @requested_whiteboards = session.user.ownership_requests.map { |x| x.group }
 		    @requested_groups = session.user.membership_requests.map { |x| x.group }
 		    render :user_home
 		else
 		    # Welcome splash screen
		  	@whiteboards = Whiteboard.all(:public => true)
		  	@groups = Group.all(:public => true)
		    render :layout => false
		end
  end
  
end
