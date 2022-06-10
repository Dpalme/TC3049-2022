# Final Project: Quiz Application with Microservices
# Date: 10-Jun-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar


# Question class interactor, user injects the gateway use for query. May be inmemory, sql, aws, etc.
class QuestionInteractor

  # Using dependency Injection principle we make our logic layer more flexible
  def initialize(question_gateway)
    @question_gateway = question_gateway
  end

  # Get All questions until n
  def all(n)
    @question_gateway.fetch_questions(n)
  end
end
