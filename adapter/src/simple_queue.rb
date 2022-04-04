# File: simple_queue.rb

# IMPORTANT: Do not modify the following class in any way!

class SimpleQueue

    # Creates an empty list
    def initialize
      @info =[]
    end
  
    # Insterts into the list and returns a reference to self
    def insert(x)
      @info.push(x)
      self
    end
  
    # checks if the list is empty, shifts if not
    def remove
      if empty?
        raise "Can't remove if queue is empty"
      else
        @info.shift
      end
    end

    # Checks if the list is empty
    def empty?
      @info.empty?
    end
  
    # Returns the size of the list
    def size
      @info.size
    end
  
    # Returns the string representation of the list
    def inspect
      @info.inspect
    end
  
  end