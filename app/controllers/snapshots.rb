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
    
    @previous = @snapshot.previous
    @next = @snapshot.next
    display @snapshot
  end

  def new
    only_provides :html
    check_user_owns_whiteboard
    
    @snapshot = Snapshot.new
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
    
    @snapshot = Snapshot.new(snapshot)
    @snapshot.whiteboard = @whiteboard
    @snapshot.image_url, _always_nil = image_url_from_params(@snapshot)
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
    
    @snapshot.image_url, old_image_url = image_url_from_params(@snapshot)
    if @snapshot.update_attributes(snapshot, :taken_at, :body)
      Boardlog::ImageStore.new("snapshots").try_delete_image old_image_url if old_image_url
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
    
    def image_url_from_params(current_snapshot)
      case params[:image_source]
        when "original": [current_snapshot.image_url, nil]
        when "upload": [Boardlog::ImageStore.new("snapshots").store_image(params[:image_upload]), current_snapshot.image_url]
        when "url": [params[:image_url], current_snapshot.image_url]
        else nil
      end
    end

end # Snapshots
