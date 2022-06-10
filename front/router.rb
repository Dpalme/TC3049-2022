require "sinatra"
require "json"
require "faraday"

LEADERBOARD_GW = "https://ialplejff9.execute-api.us-east-1.amazonaws.com/default/LeaderboardService"
QUESTIONS_GW = "https://35y97qpr5j.execute-api.us-east-1.amazonaws.com/default/QuestionServer?n=1"

set :sessions, true

get "/" do
  erb :index
end

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

get "/leaderboard" do
  @data = get_leaderboard
  erb :leaderboard
end

post "/leaderboard" do
  conn = Faraday.new(
    url: LEADERBOARD_GW,
    headers: { "Content-Type" => "application/json" },
  )

  response = conn.post("/default/LeaderboardService") do |req|
    req.body = JSON.dump({ username: params[:username],
                           score: params[:score].to_i,
                           num_of_questions: params[:num_of_questions].to_i })
  end
  p response
  if !response.success?
    @errorMessage = "#{response.body}\n#{response.reason_phrase}"
    return erb :error
  end
  @data = get_leaderboard
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
    @numQuestions = session[:total]
    erb :quizScore
  end
end

def fetch_questions(n)
  response = Faraday.get(QUESTIONS_GW, { n: n })
  if !response.success?
    @errorMessage = "Something went wrong please try again"
    return erb :error
  end
  JSON.parse response.body
end

=begin
get "/quiz" do
  current_question = params[:currentQuestion].to_i
  @questions = current_question
    return erb :index
  end
  begin
    @n = params[:questions].to_i
  rescue Exception
    @errorMessage = "Question number must be between 1 and 10"
    return erb :error
  end
  if @n.to_i < 1 || @n.to_i > 10
    @errorMessage = "Question number must be between 1 and 10"
    return erb :error
  end
  response = Faraday.get(QUESTIONS_GW, { n: @n })
  # if response.success?
  #   @data = JSON.parse(response.body).map do |entry|
  #     JSON.parse(entry)
  #   end
  # end
  @n = @data.length
  @data.slice(0, 10)
  erb :questions
end

post "/quiz" do
  @questions = request.body
  p @questions.string
  @score = 0
  @numQuestions = 0
  @questions.each "&" do |k|
    p k
    @numQuestions += 1
    if k[2] == "t"
      @score += 1
    end
  end
  erb :quizScore
end
=end