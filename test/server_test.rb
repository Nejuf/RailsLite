require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8000

trap('INT') { server.shutdown }


#Server starts listening
server.mount_proc '/' do |req, res| #slash specifies root
  MyController.new(req, res).go #when more advanced, will instead go to router
  #response is sent back automatically when block ends
end

server.start