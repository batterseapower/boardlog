class MembershipRequest
  include DataMapper::Resource
  
	belongs_to :user
	belongs_to :group
  
  property :id, Serial
  property :denied, Boolean, :nullable => false, :default => false

end
