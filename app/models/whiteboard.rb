class Whiteboard
  include DataMapper::Resource

  has n, :snapshots, :order => [:taken_at.asc]
  has n, :owners, :through => Resource, :class_name => 'User'
  belongs_to :group
  
  property :id, Serial
  property :name, String, :nullable => false, :length => (1..50)
  property :public, Boolean, :nullable => false

end
