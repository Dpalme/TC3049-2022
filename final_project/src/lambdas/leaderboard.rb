# Leaderboard micro-service
# Date: 09-06-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar
# References:
# https://github.com/ariel-ortiz/202211-tc3049.1/blob/main/DynamoDB/books/lambda_function.rb

require "json"
require "aws-sdk-dynamodb"

DYNAMODB = Aws::DynamoDB::Client.new
TABLE_NAME = "Leaderboard"

class HttpStatus
  OK = 200
  CREATED = 201
  BAD_REQUEST = 400
  METHOD_NOT_ALLOWED = 405
end

def make_response(code, body)
  {
    statusCode: code,
    headers: {
      "Content-Type" => "application/json; charset=utf-8",
    },
    body: JSON.generate(body),
  }
end

def make_result_list(items)
  items.map { |item| item.to_json }
  items.sort! { |a, b| a["score"] <=> b["score"] }
end

#--------------------------------------------------------------------
def get_scores
  make_result_list(DYNAMODB.scan(table_name: TABLE_NAME).items)
end

def valid_score?(score)
  return false if score.key?("username")
  return false if score.key?("score")
  return false if score.key?("created")
  return false if score.key?("num_of_questions")
  true
end

def parse_body(body)
  return nil if !body
  begin
    data = JSON.parse(body)
    return data if valid_score?(data)
    nil
  rescue JSON::ParserError
    nil
  end
end

#--------------------------------------------------------------------
def store_score(body)
  data = parse_body(body)
  return false if !data
  DYNAMODB.put_item(table_name: TABLE_NAME, item: data)
  true
end

#--------------------------------------------------------------------
def handle_get
  make_response(HttpStatus::OK, get_scores)
end

#--------------------------------------------------------------------
def handle_post
  make_response(HttpStatus::CREATED,
                { message: "Resource created or updated" })
end

#--------------------------------------------------------------------
def handle_bad_request
  make_response(HttpStatus::BAD_REQUEST,
                { message: "Bad request (invalid input)" })
end

#--------------------------------------------------------------------
def handle_bad_method(method)
  make_response(HttpStatus::METHOD_NOT_ALLOWED,
                { message: "Method not supported: #{method}" })
end

#--------------------------------------------------------------------
def lambda_handler(event:, context:)
  method = event["httpMethod"]
  case method
  when "GET"
    handle_get
  when "POST"
    if store_score(event["body"])
      handle_post
    else
      handle_bad_request
    end
  else
    handle_bad_method(method)
  end
end
