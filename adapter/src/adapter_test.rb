# File: adapter_test.rb 

require 'minitest/autorun'
require_relative 'simple_queue'
require_relative 'queue_adapter'

class QueueAdapterTest < Minitest::Test

  def test_queue_adapter
    # Creates the queue and the adapter
    q = SimpleQueue.new
    qa = QueueAdapter.new(q)

    # checks they are empty
    assert q.empty?
    assert qa.empty?
    # checks you can't pop empty
    assert_nil qa.pop
    # checks push returns self
    assert_same qa, qa.push("Foo")
    # checks peek returns single item
    assert_equal "Foo", qa.peek
    # checks list isn't empty
    refute q.empty?
    refute qa.empty?
    assert_same qa, qa.push("Bar")
    # checks peek returns last in
    assert_equal "Bar", qa.peek
    # checks push chaining
    assert_same qa, qa.push("Baz").push("Quux")
    assert_equal 4, q.size
    assert_equal 4, qa.size

    # checks peek and pop work as intended
    assert_equal "Quux", qa.peek
    assert_equal "Quux", qa.pop
    assert_equal "Baz", qa.peek
    assert_equal "Baz", qa.pop
    assert_equal "Bar", qa.peek
    assert_equal "Bar", qa.pop
    assert_equal "Foo", qa.peek
    assert_same qa, qa.push("Goo")
    assert_equal "Goo", qa.peek
    assert_equal "Goo", qa.pop
    assert_equal "Foo", qa.peek
    assert_equal 1, qa.size
    assert_equal "Foo", qa.pop
    assert_nil qa.peek
    assert_nil qa.pop
    # checks list is empty
    assert q.empty?
    assert qa.empty?
    assert_equal 0, q.size
    assert_equal 0, qa.size
  end

end