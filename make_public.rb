require 'json'

require 'net/http'
require 'uri'
require 'time'

def get_token(id)
    content = nil
    open("tokens/#{id}_token.json", "r") { |f|
      content = f.read
    }
    return JSON.parse(content)
end

def get_json_api(path, token, headers)
    fetch_url = "https://www.strava.com/api/v3"
    bearer = "Authorization: Bearer #{token["access_token"]}" 

    uri = URI.parse("#{fetch_url}/#{path}")

    response = Net::HTTP.new(uri.host, uri.port)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    path = uri.path
    if uri.query.length > 0 then
        path = path + "?"+uri.query
    end

    request = Net::HTTP::Get.new(path)

    puts "Debug: #{uri.path} #{uri}"

    request.add_field("Authorization", "Bearer #{token}")
    request.add_field("Accept", "application/json")

    headers.each do |key, value|
        request.add_field(key, value.to_s)
        puts key, value.to_s
    end

    response = http.request(request)

    payload = JSON.parse(response.body)

    return payload

end

def get_activities(access_token, before, after, page, per_page)
    return get_json_api(
        "athlete/activities?before=#{before.to_i}&after=#{after.to_i}&page=#{page}&per_page=#{per_page}",
         access_token, {})
end

def put_json_api(path, body, token)
    fetch_url = "https://www.strava.com/api/v3"
  
    bearer = "Authorization: Bearer #{token["access_token"]}" 
  
    uri = URI.parse("#{fetch_url}/#{path}")
    puts "Put to: #{uri.to_s}"
    response = Net::HTTP.new(uri.host, uri.port)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Put.new(uri.path)
    request.body = JSON.generate(body)
    request.add_field("Authorization", "Bearer #{token}")
    request.add_field("Content-Type", "application/json")
  
    response = http.request(request)
  
    payload = JSON.parse(response.body)
    
    return response.code, payload
end

def make_activity_public(access_token, activity_id)
    update_body = Hash.new
    update_body["private"] = false
    code, result = put_json_api("activities/#{activity_id}", update_body, access_token)
    return code, result
end

def make_range_public(start_date, end_date, token)
    page = 1
    per_page = 100
    data_eaten = false

    until data_eaten == true do
        activities = get_activities(token["access_token"], end_date, start_date, page, per_page)

        puts "Activities found: #{activities.length} (page: #{page})"

        activities.each do | activity |
            if activity["private"] == true then
                puts "Making #{activity["name"]} on #{activity["start_date"]} public"

                code, body = make_activity_public(token["access_token"], activity["id"])

                if code.to_i != 200 then
                    puts "Error updating #{activity["id"]} - status: #{code}"
                    puts "#{body}"
                    exit 1
                end
            end
        end

        if activities.length == 0 then
            data_eaten = true
        end

        page = page + 1
    end

end

token_file = ARGV[0]
start_date = Time::parse(ARGV[1])
end_date = Time::parse(ARGV[2])
token = get_token(token_file)

puts token, start_date, end_date

make_range_public(start_date, end_date, token)
