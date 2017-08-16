# Implement a queue with #enqueue and #dequeue, as well as a #max API,
# a method which returns the maximum element still in the queue. This
# is trivial to do by spending O(n) time upon dequeuing.
# Can you do it in O(1) amortized? Maybe use an auxiliary storage structure?

# Use your RingBuffer to achieve optimal shifts! Write any additional
# methods you need.

require_relative 'ring_buffer'

class QueueWithMax
  attr_accessor :store

  def initialize
    @store = RingBuffer.new
    @maximum = 0
    @max_history = [0]
  end

  def enqueue(val)
    @store.push(val)
    if val > @maximum
      @maximum = val
      @max_history.push(@maximum)
    end
  end

  def dequeue
    element = @store[0]
    if element >= @max_history.last
      @max_history.pop
    end
    @store.shift
  end

  def max
    @max_history.last
  end

  def length
    @store.length
  end

end
