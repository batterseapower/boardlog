require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a membership_request exists" do
  MembershipRequest.all.destroy!
  request(resource(:membership_requests), :method => "POST", 
    :params => { :membership_request => { :id => nil }})
end

describe "resource(:membership_requests)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:membership_requests))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of membership_requests" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a membership_request exists" do
    before(:each) do
      @response = request(resource(:membership_requests))
    end
    
    it "has a list of membership_requests" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      MembershipRequest.all.destroy!
      @response = request(resource(:membership_requests), :method => "POST", 
        :params => { :membership_request => { :id => nil }})
    end
    
    it "redirects to resource(:membership_requests)" do
      @response.should redirect_to(resource(MembershipRequest.first), :message => {:notice => "membership_request was successfully created"})
    end
    
  end
end

describe "resource(@membership_request)" do 
  describe "a successful DELETE", :given => "a membership_request exists" do
     before(:each) do
       @response = request(resource(MembershipRequest.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:membership_requests))
     end

   end
end

describe "resource(:membership_requests, :new)" do
  before(:each) do
    @response = request(resource(:membership_requests, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@membership_request, :edit)", :given => "a membership_request exists" do
  before(:each) do
    @response = request(resource(MembershipRequest.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@membership_request)", :given => "a membership_request exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(MembershipRequest.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @membership_request = MembershipRequest.first
      @response = request(resource(@membership_request), :method => "PUT", 
        :params => { :article => {:id => @membership_request.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@membership_request))
    end
  end
  
end

