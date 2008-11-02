require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe User, "index action" do
  before(:each) do
    dispatch_to(User, :index)
  end
end