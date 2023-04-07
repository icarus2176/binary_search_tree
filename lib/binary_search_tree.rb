class Node
  attr_reader :data
  attr_accessor :l_child, :r_child

  def initialize(data = nil, l_child = nil, r_child = nil)
    @data, @l_child, @r_child = data, l_child, r_child
  end
end

class Tree
  def initialize(array)
    @root = build_tree(array.sort.uniq)
  end

  def build_tree(values)
    array = values.sort.uniq
    if array.length == 0
      nil
    else
      half = (array.length - 1) / 2
      l_child = array.slice(0...half)
      r_child = array.slice((half + 1)...array.length)
      Node.new(array[half], build_tree(l_child), build_tree(r_child))
    end
  end

  def insert(data, node = @root)
    if data < node.data
      return node.l_child = Node.new(data) if node.l_child.nil?

      insert(data, node.l_child)
    elsif data > node.data
      return node.r_child = Node.new(data) if node.r_child.nil?

      insert(data, node.r_child)
    end
  end

  def delete(data, node = root)
    if data < node.data && node.l_child
      node.l_child = delete(data, node.l_child)
    elsif data > node.data && node.r_child
      node.r_child = delete(data, node.r_child)
    elsif data == node.data
      if !node.l_child || !node.r_child
        NULL
      elsif node.l_child
        node.l_child
      elsif node.r_child
        node.r_child
      else
        temp = min_node(node.r_child)
        node.data = temp.data
        node.r_child = delete(temp.data, node.r_child)
      end
    end
  end

  def min_node(node)
    min = node

    while min.l_child
      min = min.l_child
    end
    min
  end

  def find(data, node = @root)
    if node.data == data
      node
    elsif node.data > data && node.l_child
      find(data, node.l_child)
    elsif node.data < data && node.r_child
      find(data, node.r_child)
    end
  end

  def level_order()
    queue = [@root]
    answer = []
    until queue.empty?
      current = queue[0]
      if block_given?
        yield current
      else
        answer.push(current.data)
      end
      queue.push(current.l_child) if current.l_child
      queue.push(current.r_child) if current.r_child
      queue.shift
    end
    answer
  end

  def inorder(node = @root)
    answer = [] unless block_given?
    answer.push(inorder(node.l_child)) if node.l_child
    if block_given?
      yield node
    else
      answer.push(node.data)
    end
    answer.push(inorder(node.r_child)) if node.r_child
    answer&.flatten.uniq
  end

  def preorder(node = @root)
    answer = []
    if block_given?
      yield node
    else
      answer.push(node.data)
    end

    answer.push(preorder(node.l_child))if node.l_child
    answer.push(preorder(node.r_child)) if node.r_child
    answer&.flatten.uniq
  end

  def postorder(node = @root)
    answer = [] 
    answer.push(postorder(node.l_child)) if node.l_child
    answer.push(postorder(node.r_child)) if node.r_child
    if block_given?
      yield node 
    else
      answer.push(node.data)
    end

    answer&.flatten.uniq
  end

  def height(node)
    queue = [[node, 0]]
    highest = 0
    until queue.empty?
      current = queue[0][0]
      count = queue[0][1]
      highest = count if count > highest
      queue.push([current.l_child, count + 1]) if current.l_child
      queue.push([current.r_child, count + 1]) if current.r_child
      queue.shift
    end
    highest
  end

  def depth(node)
    current = @root
    depth = 0
    until node.data == current.data
      current = if node.data < current.data && current.l_child
                  current.l_child
                else
                  current.r_child
                end
      depth += 1
    end
    depth
  end

  def balanced?
    nodes = level_order
    leaf_depths = []
    nodes.each do |node_data|
      node = find(node_data)
      unless node.l_child || node.r_child
        leaf_depths.push(depth(node))
      end
    end
    if leaf_depths.max - leaf_depths.min <= 1
      true
    else
      false
    end
  end

  def rebalance
    nodes = preorder
    @root = build_tree(nodes)
  end
end

array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)
tree.insert(101)
tree.insert(102)
tree.insert(103)
tree.rebalance
puts tree.level_order
puts tree.balanced?