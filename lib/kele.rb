require 'httparty'

class Kele
  include HTTParty
  #@base_uri= "https://www.bloc.io/api/v1/sessions"

  def initialize (username, password)
    @username = username
    @password = password

    @bloc_api_url = "https://www.bloc.io/api/v1"

    response = self.class.post("https://www.bloc.io/api/v1/sessions",
      #query: {"username": @username, "password": @password},
      #headers: {:content_type => 'application/json'})

      #:body => {:username => @username, :password => @password}.to_json,
      #:headers => {'Content-Type' => 'application/json'})

      body: {username: @username, password: @password})

    @user_auth_token = response["auth_token"]
  end
end
