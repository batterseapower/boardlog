require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Images, "index action" do
  before(:each) do
    dispatch_to(Images, :index)
  end
end