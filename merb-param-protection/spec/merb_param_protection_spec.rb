require 'spec_helper'

describe "merb-param-protection" do
  describe "Controller" do
    it "should store the accessible parameters for that controller" do
      dispatch_to(ParamsAccessibleController, :create).send(:accessible_params_args).should == {
        :address=> [:street, :zip], :post=> [:title, :body], :customer=> [:name, :phone, :email]
      }
    end
      
    it "should store the protected parameters for that controller" do
      dispatch_to(ParamsProtectedController, :create).send(:protected_params_args).should == {
        :address=> [:long, :lat], :customer=> [:activated?, :password]
      }
    end

    it "should remove the parameters from the request that are not accessible" do
      pending("duplication?")
      @params_accessible_controller = ParamsAccessibleController.new( fake_request )
      # FIXME : this call to dispatch is where I break
      @params_accessible_controller.dispatch('create')
    end
  end

  describe "param clash prevention" do
    it "should raise an error 'cannot make accessible'" do
      lambda {
        class TestAccessibleController < Merb::Controller
          params_protected :customer => [:password]
          params_accessible :customer => [:name, :phone, :email]
          def index; end
        end
      }.should raise_error(/Cannot make accessible a controller \(.*?TestAccessibleController\) that is already protected/)
    end

    it "should raise an error 'cannot protect'" do
      lambda {
        class TestProtectedController < Merb::Controller
          params_accessible :customer => [:name, :phone, :email]
          params_protected :customer => [:password]
          def index; end
        end
      }.should raise_error(/Cannot protect controller \(.*?TestProtectedController\) that is already accessible/)
    end
  end
    
  describe "param filtering" do
    it "should remove specified params" do
      post_body = "post[title]=hello%20there&post[body]=some%20text&post[status]=published&post[author_id]=1&commit=Submit"
      request = fake_request( {:request_method => 'POST'}, {:post_body => post_body})
      request.remove_params_from_object(:post, [:status, :author_id])
      request.params[:post][:title].should == "hello there"
      request.params[:post][:body].should == "some text"
      request.params[:post][:status].should_not == "published"
      request.params[:post][:author_id].should_not == 1
      request.params[:commit].should == "Submit"
    end

    it "should restrict parameters" do
      post_body = "post[title]=hello%20there&post[body]=some%20text&post[status]=published&post[author_id]=1&commit=Submit"
      request = fake_request( {:request_method => 'POST'}, {:post_body => post_body})
      request.restrict_params(:post, [:title, :body])
      request.params[:post][:title].should == "hello there"
      request.params[:post][:body].should == "some text"
      request.params[:post][:status].should_not == "published"
      request.params[:post][:author_id].should_not == 1
      request.params[:commit].should == "Submit"
      request.trashed_params.should == {"status"=>"published", "author_id"=>"1"}
    end
  end
  
  it "should not have any plugin methods accidently exposed as actions" do
    Merb::Controller.callable_actions.should be_empty
  end

end



describe "log params filtering" do
  it "should filter :password param" do
    c = dispatch_to(LogParamsFiltered, :index, :password => "topsecret", :other => "not so secret")
    c.params[:password].should == "topsecret"
    c.params[:other].should == "not so secret"
    c.class._filter_params(c.params)["password"].should == "[FILTERED]"
    c.class._filter_params(c.params)["other"].should == "not so secret"
  end
end
