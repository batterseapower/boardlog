require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a whiteboard exists" do
  Whiteboard.all.destroy!
  request(resource(:whiteboards), :method => "POST", 
    :params => { :whiteboard => { :id => nil }})
end

describe "resource(:whiteboards)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:whiteboards))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of whiteboards" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a whiteboard exists" do
    before(:each) do
      @response = request(resource(:whiteboards))
    end
    
    it "has a list of whiteboards" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Whiteboard.all.destroy!
      @response = request(resource(:whiteboards), :method => "POST", 
        :params => { :whiteboard => { :id => nil }})
    end
    
    it "redirects to resource(:whiteboards)" do
      @response.should redirect_to(resource(Whiteboard.first), :message => {:notice => "whiteboard was successfully created"})
    end
    
  end
end

describe "resource(@whiteboard)" do 
  describe "a successful DELETE", :given => "a whiteboard exists" do
     before(:each) do
       @response = request(resource(Whiteboard.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:whiteboards))
     end

   end
end

describe "resource(:whiteboards, :new)" do
  before(:each) do
    @response = request(resource(:whiteboards, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@whiteboard, :edit)", :given => "a whiteboard exists" do
  before(:each) do
    @response = request(resource(Whiteboard.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@whiteboard)", :given => "a whiteboard exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Whiteboard.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @whiteboard = Whiteboard.first
      @response = request(resource(@whiteboard), :method => "PUT", 
        :params => { :article => {:id => @whiteboard.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@whiteboard))
    end
  end
  
end

