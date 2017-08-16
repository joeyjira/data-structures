require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize(capacity = 8)
    @length = 0
    @capacity = capacity
    @store = StaticArray.new(@capacity)
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    @store[index] = value
  end

  # O(1)
  def pop
    if @length == 0
      raise "index out of bounds"
    end
    element = @store[@length - 1]
    @store[@length - 1] = nil
    @length -= 1
    return element
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    @length += 1
    if @length > @capacity
      resize!
      @store[@length - 1] = val
    else
      @store[@length - 1] = val
    end
  end

  # O(n): has to shift over all the elements.
  def shift
    if @length == 0
      raise "index out of bounds"
    end
    element = @store[0]
    new_array = StaticArray.new(@capacity)
    i = 0

    while i < @length
      new_array[i] = @store[i + 1]
      i += 1
    end

    @store = new_array
    @length -= 1
    return element
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    @capacity += 1
    new_array = StaticArray.new(@capacity)
    new_array[0] = val

    i = 1
    @length.times do
      new_array[i] = @store[i - 1]
      i += 1
    end
    @length += 1
    @store = new_array
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" if index > self.length - 1
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    if @capacity == 0
      @capacity +=1
    else
      @capacity = @capacity * 2
    end
    new_array = StaticArray.new(@capacity)
    i = 0

    while i < @length
      new_array[i] = @store[i]
      i += 1
    end

    @store = new_array
  end
end
