# This class just dumbs down a regular Array to be statically sized.
class StaticArray
  def initialize(length)
    @array= Array.new(length)
  end

  # O(1)
  def [](index)
    @array[index]
  end

  # O(1)
  def []=(index, value)
    @array[index] = value
  end

  protected
  attr_accessor :store
end
