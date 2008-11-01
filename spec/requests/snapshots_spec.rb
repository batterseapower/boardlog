require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a snapshot exists" do
  Snapshot.all.destroy!
  request(resource(:snapshots), :method => "POST", 
    :params => { :snapshot => { :id => nil }})
end

describe "resource(:snapshots)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:snapshots))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of snapshots" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a snapshot exists" do
    before(:each) do
      @response = request(resource(:snapshots))
    end
    
    it "has a list of snapshots" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Snapshot.all.destroy!
      @response = request(resource(:snapshots), :method => "POST", 
        :params => { :snapshot => { :id => nil }})
    end
    
    it "redirects to resource(:snapshots)" do
      @response.should redirect_to(resource(Snapshot.first), :message => {:notice => "snapshot was successfully created"})
    end
    
  end
end

describe "resource(@snapshot)" do 
  describe "a successful DELETE", :given => "a snapshot exists" do
     before(:each) do
       @response = request(resource(Snapshot.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:snapshots))
     end

   end
end

describe "resource(:snapshots, :new)" do
  before(:each) do
    @response = request(resource(:snapshots, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@snapshot, :edit)", :given => "a snapshot exists" do
  before(:each) do
    @response = request(resource(Snapshot.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@snapshot)", :given => "a snapshot exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Snapshot.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @snapshot = Snapshot.first
      @response = request(resource(@snapshot), :method => "PUT", 
        :params => { :article => {:id => @snapshot.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@snapshot))
    end
  end
  
end

