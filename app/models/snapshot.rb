class Snapshot
  include DataMapper::Resource
  
  belongs_to :whiteboard
  
  property :id, Serial
  property :taken_at, DateTime
  property :image_url, String
  property :body, Text

end
