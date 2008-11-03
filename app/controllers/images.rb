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
    
    # This parameter is supplied by the snapshot "new" form, when the user chooses to change their picture
    if params[:existing_image_id]
      @image = Image.get(params[:existing_image_id])
      raise NotFound unless @image && @image.whiteboard == @whiteboard
    else
      @image = Image.new
      @image.whiteboard = @whiteboard
    end
    display @image
  end
  
  def create
    case params[:image_source]
      when "existing":
        @image = Image.get(params[:existing_image_id], :whiteboard => @whiteboard)
        raise NotFound unless @image
      when "external":
        @image = ExternalImage.new(:location => params[:external_image_url])
      when "upload":
        @image = UploadedImage.new
        begin
          @image.location = Boardlog::ImageStore.store_image(params[:upload_image_file])
          @image.taken_at_guess = Boardlog::Images.guess_image_date_time(params[:upload_image_file][:tempfile].path)
        rescue Boardlog::UnacceptableImageFormat => uif
          @image.errors.add(:general, "The image was in #{uif.format} format, but we expected one of #{Boardlog::Format.alternatives_list(Boardlog::ImageStore::ACCEPTABLE_FORMATS)}")
        end
      else raise BadRequest
    end

    @image.whiteboard = @whiteboard
    if @image.errors.empty? && @image.save
      if params[:submit] != "Preview"
        redirect resource(@whiteboard, :snapshots, :new, :image_id => @image.id), :message => {:notice => "Image was successfully created"}
      else
        render :new
      end
    else
      message[:error] = "Image failed to be created"
      render :new
    end
  end

  def destroy(id)
    @image = Image.get(id)
    raise NotFound unless @image && @image.whiteboard == @whiteboard
    
    if @image.used_in_snapshot
      display @image
    elsif @image.destroy
      redirect resource(@whiteboard, :images)
    else
      raise InternalServerError
    end
  end
  
end
