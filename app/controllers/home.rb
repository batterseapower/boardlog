class Home < Application

  def index
  	# TODO: list in the order of last activity- join with snapshots
  	@whiteboards = Whiteboard.all(:public => true)
  	@groups = Group.all(:public => true)
  	
    render :layout => false
  end
  
end
