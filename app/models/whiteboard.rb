class Whiteboard
  include DataMapper::Resource

  has n, :owners, :through => Resource, :class_name => 'User'
  belongs_to :group
  has n, :snapshots, :order => [:taken_at.asc]
  has n, :images, :order => [:taken_at_guess.asc]
  
  property :id, Serial
  property :name, String, :nullable => false, :length => (1..50)
  property :public, Boolean, :nullable => false, :default => true

end
