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
    
    # def image_url_from_params(current_snapshot, snapshot_params)
    #   current_snapshot.external_image_url, current_snapshot.internal_image, success = case params[:image_source]
    #     when "external": [snapshot_params[:external_image_url], nil, true]
    #     when "internal":
    #       image = Image.first(:id => params[:internal_image_id])
    #       [nil, image && image.url, true]
    #     else [nil, nil, false]
    #   end
    #   
    #   return success
    # end

end
