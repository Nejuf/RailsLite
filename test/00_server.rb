require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/rails_lite'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
root = File.expand_path '~/public_html'
server = WEBrick::HTTPServer.new(:Port => 8080, :DocumentRoot => root)
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
    #render_content("hello world!", "text/html")
		#render_content(req.path, "text/html")
		#redirect_to("http://www.google.com")
    # after you have template rendering, uncomment:
    #render :show

    # after you have sessions going, uncomment:
   session["count"] ||= 0
   session["count"] += 1
   render :counting_show
  end
end

#Server starts listening
server.mount_proc '/' do |req, res|
  MyController.new(req, res).go #when more advanced, will instead go to router
end

server.start
