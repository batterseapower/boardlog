class Whiteboards < Application
  before :ensure_authenticated, :only => [:new, :edit, :create, :update, :destroy,
  	:request_ownership, :accept_request, :reject_request, :block_request]
  
  # provides :xml, :yaml, :js

  def index
    @whiteboards = Whiteboard.all(:public => true, :order => [:name.asc])
    
    if session.user
    	@requested_whiteboards = session.user.ownership_requests.map { |x| x.group }
    end
    
    display @whiteboards
  end

	def request_ownership(id)
  	@whiteboard = Whiteboard.get(id)
  	raise NotFound unless @whiteboard
	 	@whiteboard.request_ownership(session.user)
  	render :show
  end

  def accept_request()
  	@whiteboard = Whiteboard.get(params[:whiteboard_id])
  	raise NotFound unless @whiteboard
  	user = User.get(params[:user_id])
  	raise NotFound unless user
  	
  	req = OwnershipRequest.first(:user_id => user.id, :whiteboard_id => @whiteboard.id)
  	raise NotFound unless req
  	
  	@whiteboard.owners.push(user)
  	@whiteboard.save 	
  	req.destroy 	
  	
  	render :show
  end
  
  def reject_request()
  	@whiteboard = Whiteboard.get(params[:whiteboard_id])
  	raise NotFound unless @whiteboard
  	user = User.get(params[:user_id])
  	raise NotFound unless user
  	
  	req = OwnershipRequest.first(:user_id => user.id, :whiteboard_id => @whiteboard.id)
  	raise NotFound unless req

  	req.destroy 	
  	
  	render :show
  end
  
  def block_request()
  	@whiteboard = Whiteboard.get(params[:whiteboard_id])
  	raise NotFound unless @whiteboard
  	user = User.get(params[:user_id])
  	raise NotFound unless user
  	
  	req = OwnershipRequest.first(:user_id => user.id, :whiteboard_id => @whiteboard.id)
  	raise NotFound unless req
  	
		req.denied = true
		req.save 	
  	
  	render :show
  end

  def show(id)
    @whiteboard = Whiteboard.get(id)
    raise NotFound unless @whiteboard
    
	  @snapshots = @whiteboard.snapshots(:limit => 10)	  
  	display @whiteboard
  end

  def new
    only_provides :html
    
    @whiteboard = Whiteboard.new
    display @whiteboard
  end

  def edit(id)
    only_provides :html
    @whiteboard = Whiteboard.get(id)
    raise NotFound unless @whiteboard
    check_user_owns_whiteboard
    
    display @whiteboard
  end

  def create(whiteboard)
    @whiteboard = Whiteboard.new(whiteboard)
    @whiteboard.owners << session.user
    if @whiteboard.save
      redirect resource(@whiteboard), :message => {:notice => "Whiteboard was successfully created"}
    else
      message[:error] = "Whiteboard failed to be created"
      render :new
    end
  end

  def update(id, whiteboard)
    @whiteboard = Whiteboard.get(id)
    raise NotFound unless @whiteboard
    check_user_owns_whiteboard
    
    if @whiteboard.update_attributes(whiteboard, :name)
       redirect resource(@whiteboard)
    else
      display @whiteboard, :edit
    end
  end

  def destroy(id)
    @whiteboard = Whiteboard.get(id)
    raise NotFound unless @whiteboard
    check_user_owns_whiteboard
    
    if @whiteboard.destroy
      redirect resource(:whiteboards)
    else
      raise InternalServerError
    end
  end

end
