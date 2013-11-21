require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'
require_relative 'flash'

class ControllerBase
  attr_reader :params
protected
  attr_accessor :req, :res
public

  def initialize(req, res, route_params)
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def already_built_response?
    @already_built_response
  end

  #sets status to 302/redirect Found 
  #not 301(Moved Permanently) because some browsers will cache the redirect
  #sets location header to new url
  def redirect_to(url)
    raise "double render error" if already_built_response?

      #redirect_status = WEBrick::HTTPStatus::TemporaryRedirect #307, not sure how to get a 302 redirect object
      #@res.set_redirect(redirect_status, url)
    @res.header['location'] = url
    @res.status = 302
    session.store_session(res)

    @already_built_response = true
    nil
  end

  #Technically, it just fills in the response body
  def render_content(content, type)
    raise "double render error" if already_built_response?

    @res.content_type = type
    @res.body = content
    session.store_session(res)
    flash.store_flash(res)

    @already_built_response = true
    nil
  end

  def render(template_name)
    controller_name = get_controller_name
    template_contents = File.read("views/#{controller_name}/#{template_name}.html.erb")
    
    erb = ERB.new(template_contents).result(binding)
    render_content(erb, "text/html")
  end

  def invoke_action(name)
    send(name)
    render(name) unless already_built_response?
  end

  def get_controller_name
    self.class.to_s.reverse.gsub("Controller".reverse, "").reverse.underscore.downcase
  end

  #Only non-GET, HTML requests are checked
  def self.protect_from_forgery

  end
end
