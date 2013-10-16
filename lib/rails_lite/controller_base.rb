require 'erb'
require 'active_support/core_ext'
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
    @session ||= Session.new(req)
  end

  def already_rendered?
  end

  def redirect_to(url)
    #sets status to 302/redirect Found 
    #not 301(Moved Permanently) because some browsers will cache the redirect
    #sets location header to new url
    @already_built_response = true
    #redirect_status = WEBrick::HTTPStatus::TemporaryRedirect
    #@res.set_redirect(redirect_status, url)
    @res.header['location'] = url
    @res.status = 302
    session.store_session(res)
  end

  def render_content(content, type)
    @already_built_response = true
    @res.content_type = type
    @res.body = content
    session.store_session(res)
  end

  def render(template_name)
    #fill in response body
    controller_name = get_controller_name
    template_contents = File.read("views/#{controller_name}/#{template_name}.html.erb")
    
    erb = ERB.new(template_contents).result(binding)
    render_content(erb, "text/html")
  end

  def invoke_action(name)
  end

  def get_controller_name
    self.class.to_s.reverse.gsub("Controller".reverse, "").reverse.underscore.downcase
  end
end
