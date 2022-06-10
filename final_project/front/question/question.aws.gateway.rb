require "faraday"
require 'singleton'

# AWS API entry URL
QUESTIONS_GW = "https://35y97qpr5j.execute-api.us-east-1.amazonaws.com/default/QuestionServer"

# Question AWS API entry point
class QuestionAwsGateway
  include Singleton

  # Fetch n or lower number of questions
  def fetch_questions(n)
    response = Faraday.get(QUESTIONS_GW, { n: n })
    unless response.success?
      @error_message = "Something went wrong please try again"
      return erb :error
    end
    JSON.parse response.body
  end
end
