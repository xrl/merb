require 'spec_helper'

describe MerbExceptions::DefaultExceptionExtensions do

  before(:each) do
    Merb::Router.prepare do
      default_routes
    end
  end

  it "should notify_of_exceptions" do
    MerbExceptions::Notification.should_receive(:new)
    with_level(:fatal) do
      visit("/raise_error/index") rescue nil
    end
  end

end
