require_relative "static_array"
require "byebug"

class RingBuffer
  attr_reader :length

  def initialize
    @length = 0
    @capacity = 8
    @start_idx = @capacity/2 + 1
    @end_idx = @capacity/2
    @store = StaticArray.new(@capacity)
  end

  # O(1)
  def [](index)
    check_index(index)
    true_index = @start_idx + index + 1
    if true_index > @capacity - 1
      true_index = true_index - @capacity
    end

    @store[true_index - 1]
  end

  # O(1)
  def []=(index, val)
    true_index = @start_idx + index + 1
    if true_index > @capacity - 1
      true_index = true_index - @capacity
    end

    @store[true_index - 1] = val
  end

  # O(1)
  def pop
    raise "index out of bounds" if @length == 0
    element = @store[@end_idx]
    @store[@end_idx] = nil

    @end_idx -= 1
    if @end_idx < 0
      @end_idx = @capacity - 1
    end

    @length -= 1
    return element
  end

  # O(1) ammortized
  def push(val)
    length = @length + 1
    if length > @capacity
      resize!
    end

    @end_idx += 1

    if @end_idx == @capacity
      @end_idx = 0
    end

    @store[@end_idx] = val
    @length = length
    @store
  end

  # O(1)
  def shift
    raise "index out of bounds" if @length == 0
    element = @store[@start_idx]
    @store[@start_idx] = nil

    @start_idx += 1

    if @start_idx == @capacity
      @start_idx = 0
    end

    @length -= 1
    return element
  end

  # O(1) ammortized
  def unshift(val)
    length = @length + 1
    if length > @capacity
      resize!
    end

    @start_idx -= 1
    if @start_idx < 0
      @start_idx = @capacity - 1
    end

    @store[@start_idx] = val
    @length = length
    @store
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" if index > self.length - 1
  end

  def resize!
    if @capacity == 0
      new_capacity = 1
    else
      new_capacity = @capacity * 2
    end

    new_store = StaticArray.new(new_capacity)
    new_start_idx = new_capacity / 2

    new_track = new_start_idx
    old_track = @start_idx

    @length.times do
      new_store[new_track] = @store[old_track]

      new_track += 1
      old_track += 1

      if new_track == new_capacity
        new_track = 0
      end

      if old_track == @capacity
        old_track = 0
      end
    end

    @store = new_store
    @capacity = new_capacity
    @start_idx = new_start_idx
    @end_idx = new_track - 1
  end
end
