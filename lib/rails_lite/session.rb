require 'json'
require 'webrick'

class Session
	COOKIE_NAME = "_rails_lite_app"#TODO: Fetch cookie name from a configuration file

  def initialize(req)
  	cookie = req.cookies.select{ |cookie| cookie.name == COOKIE_NAME }.first

    @data = cookie.nil? ? {} : JSON.parse(cookie.value)
  end

  #e.g. session[:session_token]
  def [](key)
  	@data[key]
  end

  #e.g. session[:session_token] = nil
  def []=(key, val)
  	@data[key] = val
  end

  def store_session(res)
  	cookie = WEBrick::Cookie.new(COOKIE_NAME, @data.to_json)
  	res.cookies << cookie
  end
end
