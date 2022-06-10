# Leaderboard interactor class
class LeaderboardInteractor
  # Using dependency Injection principle we make more flexible our logic layer
  def initialize(leaderboard_gateway)
    @leaderboard_gateway = leaderboard_gateway
  end

  # Creates new leaderboard registry
  def create(leaderboard_registry)
    @leaderboard_gateway.create leaderboard_registry
  end

  # Get all leaderboard_registries, order by score desc
  def all
    registries = @leaderboard_gateway.fetch_all
    sorted = registries.sort { |a, b| b[:scores].to_f <=> a[:scores].to_f }
    p sorted
    sorted
  end
end