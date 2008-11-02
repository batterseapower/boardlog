class Images < Application
  include Boardlog::WhiteboardChildResource
  
  before :ensure_authenticated
  before :check_user_owns_whiteboard
  
  # provides :xml, :yaml, :js

  def index
    @images = @whiteboard.images
    display @images
  end

  def show(id)
    @image = Image.get(id)
    raise NotFound unless @image && @image.whiteboard == @whiteboard
    
    display @image
  end
  
  def new
    only_provides :html
    
    @image = Image.new
    display @image
  end
  
  def create
    @image = Image.new
    @image.whiteboard = @whiteboard
    @image.taken_at_guess = Boardlog::Images.guess_image_date_time(params[:image_upload][:tempfile].path)
    begin
      @image.filename = Boardlog::ImageStore.store_image(params[:image_upload])
    rescue Boardlog::UnacceptableImageFormat => uif
      @image.errors.add(:general, "The image was in #{uif.format} format, but we expected one of #{Boardlog::Format.alternatives_list(Boardlog::ImageStore::ACCEPTABLE_FORMATS)}")
    end
    if @image.errors.empty? && @image.save
      # TODO: redirect to alternative address
      redirect resource(@whiteboard, @image), :message => {:notice => "Image was successfully created"}
    else
      message[:error] = "Image failed to be created"
      render :new
    end
  end

  def destroy(id)
    @image = Image.get(id)
    raise NotFound unless @image && @image.whiteboard == @whiteboard
    
    if @image.destroy
      redirect resource(@whiteboard, :images)
    else
      raise InternalServerError
    end
  end
  
end
