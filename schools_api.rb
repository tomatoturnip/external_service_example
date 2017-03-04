require "httparty"

class SchoolsAPI
  AUTH_KEY = "some-api-key"

  def get_target_district
    response = HTTParty.get("http://foo.example.com/api/v1/districts/self", format: :plain, headers: { "X-Auth-Token" => AUTH_KEY })
    JSON.parse(response)
  end

  def get_district_selections
    response = HTTParty.get("http://foo.example.com/api/v1/districts/selections", format: :plain, headers: { "X-Auth-Token" => AUTH_KEY })
    JSON.parse(response)
  end
end
