require 'httparty'
require 'json'
require_relative 'roadmap'

class Kele
  include HTTParty
  include JSON
  include Roadmap

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
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability",
      headers: { "authorization" => @user_auth_token})
    JSON.parse(response.body)
  end

  def get_messages(*page_num)
    @page_num = page_num[0].to_i
    if @page_num >= 1
      response = self.class.get("https://www.bloc.io/api/v1/message_threads",
        body: {page: @page_num},
        headers: { "authorization" => @user_auth_token})
    else
      response = self.class.get("https://www.bloc.io/api/v1/message_threads",
        headers: { "authorization" => @user_auth_token})
    end
    JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, subject, stripped_text, *token)
    @sender = sender
    @recipient_id = recipient_id
    @subject = subject
    @stripped_text = stripped_text
    @token = token[0].to_s

    puts @token

    response = self.class.post("https://www.bloc.io/api/v1/messages",
      body: {sender: @sender, recipient_id: @recipient_id, token: @token, subject: @subject, stripped_text: @stripped_text},
      headers: { "authorization" => @user_auth_token})
    JSON.parse(response.body)
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    @checkpoint_id = checkpoint_id
    @assignment_branch = assignment_branch
    @assignment_commit_link = assignment_commit_link
    @comment = comment
    @enrollment_id = 30900

    response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions",
      body: {checkpoint_id: @checkpoint_id, assignment_branch: @assignment_branch, assignment_commit_link: @assignment_commit_link, comment: @comment, enrollment_id: @enrollment_id},
      headers: { "authorization" => @user_auth_token})

    JSON.parse(response.body)
  end

end
