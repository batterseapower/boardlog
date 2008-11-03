class Snapshots < Application
  include Boardlog::WhiteboardChildResource
  
  before :ensure_authenticated, :only => [:new, :edit, :create, :update, :destroy]
  
  # provides :xml, :yaml, :js

  def index
    @snapshots = @whiteboard.snapshots
    display @snapshots
  end

  def show(id)
    @snapshot = Snapshot.get(id)
    raise NotFound unless @snapshot && @snapshot.whiteboard == @whiteboard
    
    @previous = @snapshot.previous
    @next = @snapshot.next
    display @snapshot
  end

  def new
    only_provides :html
    check_user_owns_whiteboard
    
    image = Image.get(params[:image_id])
    return redirect_to_image_chooser if should_redirect_for(image)
    
    @snapshot = Snapshot.new
    @snapshot.whiteboard = @whiteboard
    @snapshot.image = image
    @snapshot.taken_at = Time.now
    display @snapshot
  end

  def edit(id)
    only_provides :html
    check_user_owns_whiteboard
    @snapshot = Snapshot.get(id)
    raise NotFound unless @snapshot && @snapshot.whiteboard == @whiteboard
    
    display @snapshot
  end

  def create(snapshot)
    check_user_owns_whiteboard
    
    image = Image.get(params[:image_id])
    return redirect_to_image_chooser if should_redirect_for(image)
    
    @snapshot = Snapshot.new(snapshot)
    @snapshot.whiteboard = @whiteboard
    @snapshot.image = image
    if @snapshot.save
      redirect resource(@whiteboard, @snapshot), :message => {:notice => "Snapshot was successfully created"}
    else
      message[:error] = "Snapshot failed to be created"
      render :new
    end
  end

  def update(id, snapshot)
    check_user_owns_whiteboard
    @snapshot = Snapshot.get(id)
    raise NotFound unless @snapshot && @snapshot.whiteboard == @whiteboard
    
    image = Image.get(params[:image_id])
    return redirect_to_image_chooser if should_redirect_for(image)

    @snapshot.image = image
    if @snapshot.update_attributes(snapshot, :taken_at, :use_external_image, :external_image_url, :internal_image, :body)
      redirect resource(@whiteboard, @snapshot)
    else
      display @snapshot, :edit
    end
  end

  def destroy(id)
    check_user_owns_whiteboard
    @snapshot = Snapshot.get(id)
    raise NotFound unless @snapshot && @snapshot.whiteboard == @whiteboard
    
    if @snapshot.destroy
      redirect resource(@whiteboard, :snapshots)
    else
      raise InternalServerError
    end
  end
  
  private
  
    # The "new" action expects the image_id parameter in order to set up a new snapshot. If it is missing
    # the user is redirected to the image resource "new" action, which redirects back here later on
  
    def should_redirect_for(image)
      !image || image.whiteboard != @whiteboard
    end
  
    def redirect_to_image_chooser
      redirect resource(@whiteboard, :images, :new)
    end

end
