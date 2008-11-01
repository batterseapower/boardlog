class Whiteboard
  include DataMapper::Resource

  has n, :snapshots, :order => [:taken_at.asc]
  has n, :owners, :through => Resource, :class_name => 'User'
  
  property :id, Serial
  property :name, String, :length => (1..50)

end
