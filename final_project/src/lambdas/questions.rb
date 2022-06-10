# Questions micro-service
# Date: 09-06-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar
# References:
# https://github.com/ariel-ortiz/202211-tc3049.1/blob/main/DynamoDB/books/lambda_function.rb

require "json"
require "aws-sdk-dynamodb"

# Connection to DynamoDB table
DYNAMODB = Aws::DynamoDB::Client.new
TABLE_NAME = "Questions"

# Enumerator for HTTP Statuses
class HttpStatus
  OK = 200
  CREATED = 201
  BAD_REQUEST = 400
  METHOD_NOT_ALLOWED = 405
end

# Creates http response
def make_response(code, body)
  {
    statusCode: code,
    headers: {
      "Content-Type" => "application/json; charset=utf-8",
    },
    body: JSON.generate(body),
  }
end

# Gets n random questions from the DynamoDB table
def get_questions(n)
  DYNAMODB.scan(table_name: TABLE_NAME).items.shuffle().slice(0, n)
end

# checks if the hashmap is a valid question
def valid_question?(question)
  return false if question.key?("Question")
  return false if question.key?("Answers")
  answers = question["Answers"]
  answers.each do |answer|
    return false if answer.key?("Text")
    return false if answer.key?("Correct")
  end
  return true
end

# Parses and returns the body if it's a valid question
def parse_body(body)
  return nil if !body
  begin
    data = JSON.parse body
    return data if valid_question? data
    nil
  rescue JSON::ParserError
    nil
  end
end

# Stores the question in the DynamoDB table if it's valid
def store_question(body)
  data = parse_body body
  return false if !data
  DYNAMODB.put_item(table_name: TABLE_NAME, item: data)
  true
end

# Different handle functions that send the proper response codes and messages
def handle_get(n)
  make_response(HttpStatus::OK, get_questions(n))
end

def handle_post
  make_response(HttpStatus::CREATED,
                { message: "Resource created or updated" })
end

def handle_bad_request
  make_response(HttpStatus::BAD_REQUEST,
                { message: "Bad request (invalid input)" })
end

def handle_bad_method(method)
  make_response(HttpStatus::METHOD_NOT_ALLOWED,
                { message: "Method not supported: #{method}" })
end

# Main handler that routes business logic based on the request method
def lambda_handler(event:, context:)
  method = event["httpMethod"]
  case method
  when "GET"
    begin
      n = event["queryStringParameters"]["n"].to_i
      if 0 < n and n < 11
        handle_get n
      else
        handle_bad_request
      end
    rescue Exception
      handle_bad_request
    end
  when "POST"
    if store_question event["body"]
      handle_post
    else
      handle_bad_request
    end
  else
    handle_bad_method method
  end
end
