class Node
  include Comparable

  attr_accessor :data, :left, :right
  
  def <=>(other)
    @data <=> other
  end

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end