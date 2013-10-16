class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method.downcase.to_sym
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    http_method == req.request_method.downcase.to_sym && pattern.match(req.path)
  end

  def run(req, res)
    # p "Route Run"
    # p "pattern: #{pattern}"
    # p "captures: #{pattern.match(req.path).captures}"
    # p "named_captures: #{pattern.named_captures}"
    # p "names: #{pattern.names}"
    # named_captures value is an index, so we're better off using #names and #captures
    route_params = {}
    captures = pattern.match(req.path).captures
    pattern.names.each_with_index do |param_name, index|
      route_params[param_name.to_sym] = captures[index]
    end    
    controller_class.new(req, res, route_params).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, http_method, controller_class, action_name)
    @routes << Route.new(pattern, http_method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval &proc
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method("#{http_method}") do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end
    nil
  end

  def run(req, res)
    route = match(req)

    if route.nil?
      res.status = 404
    else
      route.run(req, res)
    end
  end
end
