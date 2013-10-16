require 'json'
require 'webrick'
require 'debugger'

class Session
	COOKIE_NAME = "_rails_lite_app"
  def initialize(req)
    debugger
  	cookie = req.cookies.select{ |cookie| 
      cookie.name == COOKIE_NAME }.first
		if cookie.nil?
			@data = {}
		else
			@data = JSON.parse(cookie.value)
		end
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
