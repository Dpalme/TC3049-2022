require "singleton"
require "faraday"

CREATE_LEADERBOARD_GW = "https://2lzsjb9r4b.execute-api.us-east-1.amazonaws.com"
LEADERBOARD_GW = "https://ialplejff9.execute-api.us-east-1.amazonaws.com/default/LeaderboardService"

# Interface for the Leaderboard Microservice
class LeaderboardAwsGateway
  include Singleton

  # POSTs a new score to the leaderboard
  def create(leaderboard_registry)
    conn = Faraday.new(
      url: CREATE_LEADERBOARD_GW,
      headers: { "Content-Type" => "application/json" },
    )

    conn.post("/default/CreateLeaderboard") do |req|
      req.body = JSON.dump({ username: leaderboard_registry[:username],
                             score: leaderboard_registry[:score].to_i,
                             num_of_questions: leaderboard_registry[:num_of_questions].to_i })
    end
  end

  # Gets all scores from the leaderboard
  def fetch_all
    response = Faraday.get(LEADERBOARD_GW)
    p response
    @data = []
    if response.success?
      @data = JSON.parse(response.body).map do |entry|
        JSON.parse entry
      end
    end
    @data
  end
end
