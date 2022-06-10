# Leaderboard interactor class
class LeaderboardInteractor
  # Using dependency Injection principle we make our logic layer more flexible
  def initialize(leaderboard_gateway)
    @leaderboard_gateway = leaderboard_gateway
  end

  # Creates new leaderboard registry
  def create(leaderboard_registry)
    @leaderboard_gateway.create leaderboard_registry
  end

  # Gets all leaderboard_registries, ordered by score desc
  def all
    @data = @leaderboard_gateway.fetch_all
    @data.each { |entry| p entry["score"] }
    @data.sort { |a, b| b["num_of_questions"].to_f <=> a["num_of_questions"].to_f }
      .sort { |a, b| b["score"].to_f <=> a["score"].to_f }
  end
end
