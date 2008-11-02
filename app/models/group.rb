class Group
  include DataMapper::Resource
  
  has n, :whiteboards
  has n, :users
	  
  property :id, Serial
  property :name, String, :nullable => false, :length => (1..512)
  property :public, Boolean, :nullable => false


end
