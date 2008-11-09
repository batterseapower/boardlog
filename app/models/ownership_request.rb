class OwnershipRequest
  include DataMapper::Resource
  
	belongs_to :user
	belongs_to :whiteboard
  
  property :id, Serial
  property :denied, Boolean, :nullable => false, :default => false



end
