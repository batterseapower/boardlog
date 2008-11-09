class Whiteboard
  include DataMapper::Resource

  has n, :owners, :through => Resource, :class_name => 'User'
  belongs_to :group
  has n, :snapshots, :order => [:taken_at.asc]
  has n, :images, :order => [:taken_at_guess.asc]
  has n, :ownership_requests 
  
  property :id, Serial
  property :name, String, :nullable => false, :length => (1..50)
  property :public, Boolean, :nullable => false, :default => true
  
  def has_owner?(user)
  	owners.member?(user)
  end
  
	def has_owner_request?(user)
		!OwnershipRequest.first('whiteboard.id' => self.id, 'user.id' => user.id).nil?
	end
  
	def request_ownership(user)
		if !self.has_owner?(user) and !self.has_owner_request?(user)
  		OwnershipRequest.new(:user => user, :whiteboard => self).save
  	end
	end
	
	def get_ownership_request(user)
		OwnershipRequest.first('user.id' => user.id, 'whiteboard.id' => self.id)
	end
	
	def get_current_ownership_requests()
		OwnershipRequest.all('whiteboard.id' => self.id, 'denied' => false)
	end

end
