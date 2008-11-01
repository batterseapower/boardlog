class Whiteboards < Application
  before :ensure_authenticated, :only => [:new, :edit, :create, :update, :destroy]
  
  # provides :xml, :yaml, :js

  def index
    @whiteboards = Whiteboard.all
    display @whiteboards
  end

  def show(id)
    @whiteboard = Whiteboard.get(id)
    raise NotFound unless @whiteboard
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
    whiteboard.owners << session.user
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
    if @whiteboard.update_attributes(whiteboard)
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
