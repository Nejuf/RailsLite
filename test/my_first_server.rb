require 'webrick'
require_relative '../lib/rails_lite'

root = File.expand_path '~/public_html'
server = WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => root)

trap('INT') {server.shutdown}

class MyController < ControllerBase
	def go
		render_content(req.path, "text/html")
	end
end

server.mount_proc '/' do |req, res|
	MyController.new(req, res).go
end

server.start