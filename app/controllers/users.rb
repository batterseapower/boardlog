class Users < Application

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
    render
  end
   
  def create(user)
	@user = User.new(user)
    if @user.save
      redirect resource(@user), :message => {:notice => "New user was successfully created"}
    else
      message[:error] = "User failed to be created"
      render :new
    end
  end
   
  def new
  	@user = User.new
  	display @user
  end
  
  def show(id)
    @user = User.get(id)
    raise NotFound unless @user
    
    display @user
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
end
