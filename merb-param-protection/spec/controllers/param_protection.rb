class LogParamsFiltered < Merb::Controller
  log_params_filtered :password
  
  def index
    params
  end
end

class ParamsAccessibleController < Merb::Controller
  params_accessible :customer => [:name, :phone, :email], :address => [:street, :zip]
  params_accessible :post => [:title, :body]
  def create; end
end

class ParamsProtectedController < Merb::Controller
  params_protected :customer => [:activated?, :password], :address => [:long, :lat]
  def create; end
end
