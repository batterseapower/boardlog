class Snapshot
  include DataMapper::Resource
  
  belongs_to :whiteboard
  
  property :id, Serial
  property :taken_at, DateTime, :nullable => false
  
  property :use_external_image, Boolean, :nullable => false
  property :external_image_url, String, :nullable => true, :length => (1..512)
  belongs_to :internal_image, :class_name => "Image" # Funny sort of "belongs" relationship, in particular parent may be NULL
  
  property :body, Text, :nullable => false

  validates_with_method :check_image

  def previous
    whiteboard.snapshots.first(:taken_at.lt => taken_at)
  end
  
  def next
    whiteboard.snapshots.first(:taken_at.gt => taken_at)
  end

  def image_url
    external_image_url || (internal_image && internal_image.url)
  end

  def image_external?
    !!use_external_image
  end
  
  def image_internal?
    !use_external_image
  end

  def body_html
    # We don't bother caching this in the database or even in memory.. for now
    Boardlog::Sanitize.sanitize_markdown(body)
  end
  
  private
  
    def check_image
      if use_external_image
        external_image_url ? true : [false, "You must specify an external image URL"]
      else
        internal_image ? true : [false, "You must specify an uploaded image"]
      end
    end

end
