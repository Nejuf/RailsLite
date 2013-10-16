require 'uri'

class Params
  def initialize(req, route_params)
    # p "Params#initialize"
    # p req.query
    # p req.query_string
    # p req.path
    # p route_params
    # p req.body
    @params = route_params.merge(req.query)
    unless req.body.nil?
      body_params = parse_www_encoded_form(req.body)
      @params = @params.merge(body_params)
    end
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    decoded_params = Hash.new
    url_pairs = URI.decode_www_form(www_encoded_form)#returns array of pairs
    
    url_pairs.each do |pair|
      key = pair[0]
      value = pair[1]

      scope = decoded_params
      key_seq = parse_key(key)
      key_seq.each_with_index do |key, index|
        if (index+1) == key_seq.count
          scope[key] = value
        else
          score[key] ||= {}
          scope = scope[key]
        end
      end
    end
    decoded_params
  end

  # Converts nested keys into array pair
  # e.g. "user[user_name]" -> ["user", "name"]
  def parse_key(key)
    match_data = /(?<head>.*)\[(?<rest>.*)\]/.match(key)

    if match_data
      parse_key(match_data["rest"]).unshift(match_data["head"])
    else
      [key]
    end
    #e.g. cat[owner][house]
    # match_data["head"] -> "cat[owner]"
    # match_data["rest"] -> "house"
    # parse_key("house") -> ["house"]
    # ["house"].unshift("cat[owner]") -> ["cat[owner]", "house"]
  end
end
