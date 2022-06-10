require_relative "question/question.interactor"
require_relative "question/question.aws.gateway"
require_relative "leaderboard/leaderboard.interactor"
require_relative "leaderboard/leaderboard.aws.gateway"
require "sinatra"
require "json"
require "faraday"

$leaderboard_interactor = LeaderboardInteractor.new(LeaderboardAwsGateway.instance)
$question_interactor = QuestionInteractor.new(QuestionAwsGateway.instance)

set :sessions, true

get "/" do
  erb :index
end

get "/leaderboard" do
  @data = $leaderboard_interactor.all
  erb :leaderboard
end

post "/leaderboard" do
  response = $leaderboard_interactor.create(params)
  p response
  unless response.success?
    @error_message = "#{response.body}\n#{response.reason_phrase}"
    return erb :error
  end
  @data = $leaderboard_interactor.all
  erb :leaderboard
end

get "/quiz" do
  session[:questions] = fetch_questions params[:total]
  if params[:total].to_i < session[:questions].length
    session[:total] = session[:questions].length
  else
    session[:total] = params[:total].nil? ? 10 : params[:total].to_i
  end
  session[:score] = 0
  erb redirect "/quiz/inProgress?current=0"
end

get "/quiz/inProgress" do
  @current_question = params["current"].to_i
  @n = session[:total]
  @data = session[:questions].at(@current_question)
  erb :questions
end

post "/quiz" do
  session[:score] += params["question"] == "true" ? 1 : 0
  next_question = params["currentQuestion"].to_i + 1
  if next_question < session[:total]
    redirect "/quiz/inProgress?current=#{next_question}"
  else
    @score = session[:score]
    @num_questions = session[:total]
    erb :quizScore
  end
end

def fetch_questions(n)
  $question_interactor.all(n)
end
