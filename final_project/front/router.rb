# Quiz App Client
# Date: 09-06-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar
# References:
# https://github.com/ariel-ortiz/202211-tc3049.1/blob/main/DynamoDB/books/lambda_function.rb

require "sinatra"
require "json"
require "faraday"

# Gateway Endpoints constants
LEADERBOARD_GW = "https://ialplejff9.execute-api.us-east-1.amazonaws.com/default/LeaderboardService"
QUESTIONS_GW = "https://35y97qpr5j.execute-api.us-east-1.amazonaws.com/default/QuestionServer?n=1"

# Enables
set :sessions, true

# Root endpoint renders index with the form
get "/" do
  erb :index
end

def renderError(errorMessage)
  @errorMessage = errorMessage
  return erb :error
end

# makes the request to the lambda and gets the leaderboard table
def get_leaderboard
  response = Faraday.get(LEADERBOARD_GW)
  @data = []
  if response.success?
    @data = JSON.parse(response.body).map do |entry|
      JSON.parse entry
    end
  end
  @data
end

# Renders the leaderboard template with the data from the lambda
get "/leaderboard" do
  @data = get_leaderboard
  erb :leaderboard
end

# Sends the data to the leaderboard lambda to register the score
post "/leaderboard" do
  data = { username: params[:username],
           score: params[:score].to_i,
           created: Time.now.strftime("%Y/%m/%d"),
           num_of_questions: params[:num_of_questions].to_i }

  response = Faraday.post(LEADERBOARD_GW, JSON.dump(data), { "Content-Type" => "application/json" })

  if !response.success?
    return renderError "#{response.body}\n#{response.reason_phrase}"
  end
  @data = get_leaderboard
  erb :leaderboard
end

# Sets everything up for the quiz flow
get "/quiz" do
  # ensures the parameter is there
  if params[:total].nil?
    return renderError "Missing total parameter in url"
  end

  # Ensures the total param is a number
  begin
    n = params[:total].to_i
  rescue Exception
    return renderError "Missing total parameter in url"
  end

  session[:questions] = fetch_questions n

  # checks if the lambda has enough questions, if not, it maxes out
  if params[:total].to_i < session[:questions].length
    session[:total] = session[:questions].length
  else
    session[:total] = params[:total].to_i
  end

  session[:score] = 0
  erb redirect "/quiz/inProgress?current=0"
end

# Iterates over the questions for the quiz
get "/quiz/inProgress" do
  @current_question = params["current"].to_i
  @n = session[:total]
  @data = session[:questions].at(@current_question)
  erb :questions
end

# checks the answers and keeps tally of the score
post "/quiz" do
  session[:score] += params["question"] == "true" ? 1 : 0
  next_question = params["currentQuestion"].to_i + 1
  if next_question < session[:total]
    redirect "/quiz/inProgress?current=#{next_question}"
  else
    @score = session[:score]
    @numQuestions = session[:total]
    erb :quizScore
  end
end

# Gets the questions from the lambda
def fetch_questions(n)
  begin
    response = Faraday.get(QUESTIONS_GW, { n: n.to_i })
    if !response.success?
      return renderError "Something went wrong please try again"
    end
    JSON.parse response.body
  rescue Exception
    return renderError "N must be a number"
  end
end
