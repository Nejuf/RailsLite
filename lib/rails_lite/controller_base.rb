require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params
protected
  attr_accessor :req, :res
public

  def initialize(req, res, route_params={})
    @req = req
    @res = res
    @params = route_params
  end

  def session
  end

  def already_rendered?
  end

  def redirect_to(url)
    #set status to 302/redirect
    #set location header to new url
  end

  def render_content(content, type)
    @res.content_type = type
    @res.body = content
  end

  def render(template_name)
    #fill in response body
  end

  def invoke_action(name)
  end
end
