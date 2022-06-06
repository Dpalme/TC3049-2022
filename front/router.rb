require "sinatra"
require "json"
require "faraday"

LEADERBOARD_GW = ""
QUESTIONS_GW = "https://atw3z54ud4.execute-api.us-east-1.amazonaws.com/default/questions"

get "/" do
  erb :index
end

get "/leaderboard" do
  response = Faraday.get(LEADERBOARD_GW + "/scores")
  @data = []
  if response.success?
    @data = JSON.parse(response.body)
  end
  erb :leaderboard
end

get "/quiz" do
  n = params[:questions]
  if n.to_i < 1 || n.to_i > 10
    @errorMessage = "Question number must be between 1 and 10"
    return erb :error
  end
  response = Faraday.get(QUESTIONS_GW)
  @totalQuestions = n
  @data = []
  if response.success?
    @data = JSON.parse(response.body).map do |entry|
      JSON.parse(entry)
    end
  end
  erb :question
end
