class Groups < Application
  # provides :xml, :yaml, :js
  before :ensure_authenticated, :only => [:edit, :update, :destroy, :new, :create, :request_membership, 
  	:accept_request, :reject_request, :block_request]

  def index
    @groups = Group.all(:public => true, :order => [:name.asc])
    if session.user
    	# turn this into a join
    	@requested_groups = session.user.membership_requests.map { |x| x.group }
    end

    display @groups
  end

  def request_membership(id)
  	@group = Group.get(id)
  	raise NotFound unless @group
	 	@group.request_membership(session.user)
  	render :show
  end
  
  def accept_request()
  	@group = Group.get(params[:group_id])
  	raise NotFound unless @group
  	user = User.get(params[:user_id])
  	raise NotFound unless user
  	
  	req = MembershipRequest.first(:user_id => user.id, :group_id => @group.id)
  	raise NotFound unless req
  	
  	@group.members.push(user)
  	@group.save 	
  	req.destroy 	
  	
  	render :show
  end
  
  def reject_request()
  	@group = Group.get(params[:group_id])
  	raise NotFound unless @group
  	user = User.get(params[:user_id])
  	raise NotFound unless user
  	
  	req = MembershipRequest.first(:user_id => user.id, :group_id => @group.id)
  	raise NotFound unless req

  	req.destroy 	
  	
  	render :show
  end
  
  def block_request()
  	@group = Group.get(params[:group_id])
  	raise NotFound unless @group
  	user = User.get(params[:user_id])
  	raise NotFound unless user
  	
  	req = MembershipRequest.first(:user_id => user.id, :group_id => @group.id)
  	raise NotFound unless req
  	
		req.denied = true
		req.save 	
  	
  	render :show
  end

  def show(id)
    @group = Group.get(id)
    raise NotFound unless @group
    
    # Display if the group is public, or it is private and the user is a member of the group
    publ = @group.attribute_get(:public)
    if publ or (!publ and @group.has_member?(session.user))
    	display @group
    else
    	redirect resource(:groups)
    end
    
  end

  def new
    only_provides :html
    @group = Group.new
    display @group
  end

  def edit(id)
    only_provides :html
    
    if @group.has_member?(session.user)
	    @group = Group.get(id)
  	  raise NotFound unless @group
  	  display @group
		else
			redirect :login
		end
  end

  def create(group)
    @group = Group.new(group)
    @group.members.push(session.user)
    
    if @group.save
      redirect resource(@group), :message => {:notice => "Group was successfully created"}
    else
      message[:error] = "Group failed to be created"
      render :new
    end
  end

  def update(id, group)
    @group = Group.get(id)
    
    if @group.has_member?(session.user)
	    raise NotFound unless @group
  	  if @group.update_attributes(group)
  	     redirect resource(@group)
  	  else
  	    display @group, :edit
  	  end
		else
			# user error
			redirect :login
		end
  end

  def destroy(id)
    @group = Group.get(id)
    raise NotFound unless @group
    if @group.destroy
      redirect resource(:groups)
    else
      raise InternalServerError
    end
  end


end # Groups
