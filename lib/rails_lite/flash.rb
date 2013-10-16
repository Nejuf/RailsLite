require 'json'
require 'webrick'

class Flash < Hash

	COOKIE_NAME = '_rails_lite_app_flash'

	def initialize(req)
		@req = req
		cookie = @req.cookies.select { |cookie| cookie.name == COOKIE_NAME }.first
		unless cookie.nil?
			cookie_data = JSON.parse(cookie.value)
			self.merge(cookie_data)
		end
	end

	def now
		@temp_flash ||= {}
		@temp_flash
	end

	def store_flash(res)
		cookie = WEBrick::Cookie.new(COOKIE_NAME, self.to_json)
		res.cookies << cookie
	end
end