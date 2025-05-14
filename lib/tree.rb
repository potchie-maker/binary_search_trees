require_relative 'node'

class Tree
  attr_accessor :arr, :root

  def initialize(arr)
    @arr = arr.uniq.sort
    @root = build_tree(@arr)
  end

  def build_tree(arr)
    return nil if arr.empty?
    mid = arr.length / 2
    root = Node.new(arr[mid])
    root.left = build_tree(arr[0...mid])
    root.right = build_tree(arr[(mid + 1)..-1])

    root
  end
  
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(data)
    if @root.nil?
      @root = Node.new(data)
      return
    end
    insert_rec(data, @root)
  end

  def delete(data)
    @root = delete_rec(data, @root)
  end

  def find(data, curr = @root)
    return curr if curr.nil? || data == curr.data
    data < curr.data ? find(data, curr.left) : find(data, curr.right)
  end

  def level_order_it
    return [] if @root.nil?
    queue = [@root]
    result = []

    until queue.empty?
      curr = queue.shift
      if block_given?
        yield curr
      else
        result << curr.data
      end
      queue << curr.left if curr.left
      queue << curr.right if curr.right
    end
    result unless block_given?
  end

  # def level_order_rec(curr = @root,level = 0, result = [], &block)
  #   return [] if @root.nil?
  #   return nil if curr.nil?
  #   result << [] if result.length <= level

  #   block_given? ? yield(curr) : result[level] << curr.data

  #   level_order_rec(curr.left, level + 1, result, &block)
  #   level_order_rec(curr.right, level + 1, result, &block)

  #   block_given? ? nil : result.flatten
  # end
  
  def level_order_rec
    h = tree_height
    result = []
    (1..h).each do |level|
      current_level(@root, level, result) unless block_given?
      current_level(@root, level) { |node| yield node } if block_given?
    end
    block_given? ? nil : result
  end

  def inorder(curr = @root, result = [], &block)
    return result if curr.nil?

    inorder(curr.left, result, &block)
    block_given? ? yield(curr) : result << curr.data
    inorder(curr.right, result, &block)

    block_given? ? nil : result
  end

  def preorder(curr = @root, result = [], &block)
    return result if curr.nil?

    block_given? ? yield(curr) : result << curr.data
    preorder(curr.left, result, &block)
    preorder(curr.right, result, &block)

    block_given? ? nil : result
  end

  def postorder(curr = @root, result = [], &block)
    return result if curr.nil?

    postorder(curr.left, result, &block)
    postorder(curr.right, result, &block)
    block_given? ? yield(curr) : result << curr.data

    block_given? ? nil : result
  end

  def height(data, curr = @root)
    tree_height(find(data))
  end

  def depth(data, curr = @root, level = 0)
    return nil if curr.nil?
    return level if data == curr.data
    data < curr.data ? depth(data, curr.left, level + 1) : depth(data, curr.right, level + 1)
  end

  # def balanced?(curr = @root)
  #   return true if curr.nil?
  #   left_height = tree_height(curr.left)
  #   right_height = tree_height(curr.right)

  #   return false if (left_height - right_height).abs > 1
  #   return false unless balanced?(curr.left) && balanced?(curr.right)
  #   true
  # end
  
  def balanced?
    balanced_rec(@root) != -1
  end

  def rebalance
    @root = build_tree(inorder)
  end

  private

  def insert_rec(data, curr)
    return Node.new(data) if curr.nil?
    return curr if curr.data == data

    curr.left = insert_rec(data, curr.left) if data < curr.data
    curr.right = insert_rec(data, curr.right) if data > curr.data

    curr
  end

  def delete_rec(data, curr)
    return nil if curr.nil?
    if data < curr.data
      curr.left = delete_rec(data, curr.left)
    elsif data > curr.data
      curr.right = delete_rec(data, curr.right)
    else
      # data matches the curr.data
      
      # Case of no children
      return nil if curr.left.nil? && curr.right.nil?
      # Case of one child
      return curr.right if curr.left.nil?
      return curr.left if curr.right.nil?
      # Case of 2 children
      succ = self.get_successor(curr.right)
      curr.data = succ.data
      curr.right = delete_rec(succ.data, curr.right)
    end
    curr
  end

  def get_successor(curr)
    while curr.left
      curr = curr.left
    end
    curr
  end

  def current_level(curr, level, nodes = [], &block)
    return nil if curr.nil?
    if level == 1
      block_given? ? yield(curr) : nodes << curr.data
    else
      current_level(curr.left, level - 1, nodes, &block)
      current_level(curr.right, level - 1, nodes, &block)
    end
  end

  def tree_height(curr = @root)
    return 0 if curr.nil?
    [tree_height(curr.left), tree_height(curr.right)].max + 1
  end

  def balanced_rec(curr = @root)
    return 0 if curr.nil?

    left_height = balanced_rec(curr.left)
    right_height = balanced_rec(curr.right)

    return -1 if left_height == -1 || right_height == -1 || (left_height - right_height).abs > 1

    return [left_height, right_height].max + 1
  end
end