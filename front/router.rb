require "sinatra"
require "json"
require "faraday"

LEADERBOARD_GW = "https://7vgoqpvl66.execute-api.us-east-1.amazonaws.com/default/leaderboard"
QUESTIONS_GW = "https://atw3z54ud4.execute-api.us-east-1.amazonaws.com/default/questions"

get "/" do
  erb :index
end

get "/leaderboard" do
  response = Faraday.get(LEADERBOARD_GW + "/scores")
  @data = []
  if response.success?
    @data = JSON.parse response.body
  end
  erb :leaderboard
end

post "/leaderboard" do
  conn = Faraday.new(
    url: LEADERBOARD_GW,
    params: { param: "1" },
    headers: { "Content-Type" => "application/json" },
  )

  response = conn.post("/") do |req|
    req.body = { username: params[:username],
                 score: params[:score],
                 num_of_questions: params[:num_of_questions] }.to_json
  end

  erb :leaderboard
end

get "/quiz" do
  if !params.key? :questions
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
  @data = JSON.parse [
                       {
                         "Question": "¿Tuleperaconlapapaya?",
                         Answers: [
                           { Text: "Sip", Correct: true },
                           { Text: "Nop", Correct: false },
                           { Text: "Tampoco", Correct: false },
                         ],
                       },
                       {
                         "Question": "¿Tuleperaconlapapaya2?",
                         Answers: [
                           { Text: "Sip", Correct: true },
                           { Text: "Nop", Correct: false },
                           { Text: "Tampoco", Correct: false },
                         ],
                       },
                     ].to_json
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
