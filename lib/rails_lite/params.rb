require 'uri'

class Params
  def initialize(req, route_params)
    p "Params#initialize"
    p req.query
    p req.query_string
    p req.path
    p route_params
    p req.body
    @params = route_params.merge(req.query)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    arr = URI.decode_www_form(www_encoded_form)
    hash = Hash.new
    arr.each do |pair|
      hash[pair[0]] = pair[1]
    end
    hash
    #TODO: Use parse_key(key)
  end

  # Converts nested keys into array pair
  # e.g. "user[user_name]" -> ["user", "name"]
  def parse_key(key)
    key.split("/\]\[|\[|\]/")
  end
end
