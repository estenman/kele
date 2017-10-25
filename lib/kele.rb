require 'httparty'
require 'json'

class Kele
  include HTTParty
  include JSON

  def initialize (username, password)
    @username = username
    @password = password

    @bloc_api_url = "https://www.bloc.io/api/v1"

    response = self.class.post("https://www.bloc.io/api/v1/sessions",
      body: {email: @username, password: @password})
    @user_auth_token = response["auth_token"]

    raise "Username or password is invalid" if @user_auth_token.nil?
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me",
      headers: { "authorization" => @user_auth_token})
    result = response.body
    JSON.parse(result)
  end

  def get_mentor_availability(mentor_id)
    #2362517
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability",
      headers: { "authorization" => @user_auth_token})
    result = response.body
    JSON.parse(result)
  end
end
