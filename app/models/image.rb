class Image
  include DataMapper::Resource
  
  belongs_to :whiteboard
  
  property :id, Serial
  property :taken_at_guess, DateTime
  property :filename, String, :nullable => false, :length => (1..64)
  
  def url
    Boardlog::ImageStore::URL_BASE / filename
  end

  def absolute_path
    Boardlog::ImageStore::ABSOLUTE_PATH_BASE / absolute_path
  end

end
