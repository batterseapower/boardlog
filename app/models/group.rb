class Group
  include DataMapper::Resource
  
  has n, :whiteboards
  has n, :users, :through => Resource
	  
  property :id, Serial
  property :name, String, :nullable => false, :length => (1..50)
  property :public, Boolean, :nullable => false


end
