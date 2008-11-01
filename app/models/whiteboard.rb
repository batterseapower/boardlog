class Whiteboard
  include DataMapper::Resource

  has n, :snapshots
  has n, :owners, :through => Resource, :class_name => 'User'
  
  property :id, Serial
  property :name, String

end
