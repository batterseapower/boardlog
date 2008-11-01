class Snapshot
  include DataMapper::Resource
  
  belongs_to :whiteboard
  
  property :id, Serial
  property :taken_at, DateTime, :nullable => false
  property :image_url, String, :nullable => false
  property :body, Text, :nullable => false

end
