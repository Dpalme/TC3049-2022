# Adaptor class to turn a queue from FILO -> LIFO
class QueueAdapter
    # Initializes a new stack, using q as the adaptee.
    def initialize(queue)
        @_queue = queue
    end

    # Inserts x at the top of this stack. Returns this stack.
    def push(element)
        @_queue.insert(element)
        self
    end

    # Returns nil if this stack is empty, otherwise removes and returns its top element.
    def pop
        return nil if @_queue.empty?
        tmp = []
        while !@_queue.empty?
            tmp.push(@_queue.remove)
        end
        return_value = tmp.pop
        while !tmp.empty?
            @_queue.insert(tmp.shift)
        end
        return_value
    end

    # Returns nil if this stack is empty, otherwise returns its top element without removing it.
    def peek
        tmp = pop
        push(tmp)
        tmp
    end

    # Returns true if this stack is empty, otherwise returns false.
    def empty?
        @_queue.empty?
    end

    # Returns the number of elements currently stored in this stack.
    def size
        @_queue.size
    end
end