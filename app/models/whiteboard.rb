class Whiteboard
  include DataMapper::Resource

  has n, :owners, :through => Resource, :class_name => 'User'
  has n, :snapshots, :order => [:taken_at.asc]
  has n, :images, :order => [:taken_at_guess.asc]
  
  property :id, Serial
  property :name, String, :length => (1..50)

end
