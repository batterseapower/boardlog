class Image
  include DataMapper::Resource
  
  # We need to belong to a whiteboard as well as a snapshot because there will
  # exist a point at which the snapshot we want to attach to does not exist
  belongs_to :whiteboard
  belongs_to :snapshot
  
  property :id, Serial
  property :type, Discriminator
  property :taken_at_guess, DateTime

  # For interpretation by subclasses (they also do validation)
  property :location, String, :nullable => false, :length => (1..512)

  def is_undecided?
    true
  end

  def is_external?
    false
  end
  
  def is_uploaded?
    false
  end

end

class UploadedImage < Image
  
  def relative_filename
    location
  end

  def absolute_filename
    Boardlog::ImageStore::ABSOLUTE_PATH_BASE / relative_filename
  end
  
  def url
    Boardlog::ImageStore::URL_BASE / relative_filename
  end
  
  def is_undecided?
    false
  end

  def is_external?
    false
  end
  
  def is_uploaded?
    true
  end
  
end

class ExternalImage < Image
  
  def url
    location
  end
  
  def is_undecided?
    false
  end

  def is_external?
    true
  end
  
  def is_uploaded?
    false
  end
  
end