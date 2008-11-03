class Group
  include DataMapper::Resource
  
  has n, :whiteboards
  has n, :members, :through => Resource, :class_name => 'User'
  has n, :membership_requests
	  
  property :id, Serial
  property :name, String, :nullable => false, :length => (1..64)
  property :public, Boolean, :nullable => false
  property :location, String, :nullable => false, :length => (1..128)


	def has_member?(user)
		!Group.first('id' => self.id, 'members.user.id' => user.id).nil?
	end
	
	def has_member_request?(user)
		!MembershipRequest.first('group.id' => self.id, 'user.id' => user.id).nil?
	end
		
	def request_membership(user)
		if !self.has_member?(user) and !self.has_member_request?(user)
  		req = MembershipRequest.new
  		req.user = user
  		req.group = self
  		req.save
  	end
	end
	
	def get_membership_request(user)
		MembershipRequest.first('user.id' => user.id, 'group.id' => self.id)
	end
	
	def get_current_membership_requests()
		MembershipRequest.all('group.id' => self.id, 'denied' => false)
	end

end
