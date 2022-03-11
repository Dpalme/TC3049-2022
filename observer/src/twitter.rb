# Observer Pattern
# Date: 10-Mar-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar

# Base Twitter class, represents a user
class Twitter

  # Twitter class constructor
  def initialize(name)
    @name = name
    @followers = Hash.new()
    # ^ Hash to ensure no duplicate observers
  end

  def addListener(other)
    @followers.store(other, other)
  end

  # Chainable method to observe other Twitters
  def follow(other)
    other.addListener(self)
    self
  end

  # Calls update on all observers
  def tweet(message)
    for observer in @followers.values()
      observer.update(@name, message)
    end
  end

  # Print the event
  def update(from, message)
    print("#{@name} received a tweet from #{from}: #{message}\n")
  end
end
