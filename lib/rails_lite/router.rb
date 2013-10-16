class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method.downcase.to_sym
    @controller_class = controller_class.constantize
    @action_name = action_name
  end

  def matches?(req)
    p "matches"
    p pattern
    p req.path
    p http_method
    p req.request_method.downcase.to_sym
    p http_method == req.request_method.downcase.to_sym
    p pattern.match(req.path)
    http_method == req.request_method.downcase.to_sym && pattern.match(req.path)
  end

  def run(req, res)
    controller_class.new(req, res).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
  end

  def add_route(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    # add these helpers in a loop here
    # define method - match url to request
  end

  def match(req)
  end

  def run(req, res)
  end
end
