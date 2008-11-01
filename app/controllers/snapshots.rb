class Snapshots < Application
  before :ensure_authenticated, :only => [:new, :edit, :create, :update, :destroy]
  before :setup_whiteboard
  
  # provides :xml, :yaml, :js

  def index
    @snapshots = @whiteboard.snapshots
    display @snapshots
  end

  def show(id)
    @snapshot = Snapshot.get(id)
    raise NotFound unless @snapshot && @snapshot.whiteboard == @whiteboard
    display @snapshot
  end

  def new
    only_provides :html
    check_user_owns_whiteboard
    @snapshot = Snapshot.new
    @snapshot.taken_at = Date.today
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
    @snapshot = Snapshot.new(snapshot)
    @snapshot.whiteboard = @whiteboard
    @snapshot.image_url = Boardlog::ImageStore.store_image :directory => "snapshots", :image => params[:image]
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
    if @snapshot.update_attributes(snapshot)
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
  
    def setup_whiteboard
      @whiteboard = Whiteboard.get(params[:whiteboard_id])
      raise NotFound unless @whiteboard
    end

end # Snapshots
