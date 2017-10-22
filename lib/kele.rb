require 'httparty'

class Kele
  include HTTParty

  def initialize (username, password)
    @username = username
    @password = password

    @bloc_api_url = "https://www.bloc.io/api/v1"

    response = self.class.post("https://www.bloc.io/api/v1/sessions",
      body: {email: @username, password: @password})
    @user_auth_token = response["auth_token"]

    #raise ArgumentError, "Username or password is invalid" if @user_auth_token.nil?
    if @user_auth_token.nil?
      puts "Username or password is invalid"
    end
    #raise ArgumentError, "Username or password is invalid" unless @user_auth_token != nil
  end
end
