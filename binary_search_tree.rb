class Node
  attr_reader :data
  attr_accessor :l_child, :r_child

  def initialize(data = nil, l_child = nil, r_child =)
    @data, @l_child, @r_child = data, l_child, r_child
  end
end

class Tree
  def initialize(array)
    @root = build_tree(array.sort.uniq)
  end

  def build_tree(array)
   return if array.length <= 1
   half = array.length / 2  - 1
   l_child = array.slice(0..half)
   r_child = array.slice(half..array.length - 1)

   node = Node.new(array[half], build_tree(l_child), build_tree(r_child))
  end

  def insert(data, node = root)
    if data < node.data
      return node.l_child = Node.new(data) if node.l_child == nil
      insert(data, node.l_child)
    elsif data > node.data
      return node.r_child = Node.new(data) if node.r_child == nil
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
        return NULL
      elsif node.l_child
        return node.l_child
      elsif node.r_child
        return node.r_child
      else
        temp = min_Node(node.r_child)
        node.data = temp.data
        node.r_child = delete(temp.data, node.r_child)
      end
    end
  end
  
  def min_Node(node)
    min = node

    while min.l_child
      min = min.l_child
    end
    min
  end

  def find(data, node = root)
    if node.data = data
      return node
    elsif node.data < data && node.l_child
      find(data, node.l_child)
    elsif node.data > data && node.r_child
      find(data, node.r_child)
    else
      return nil
    end
  end

  def level_order()
    queue = [@root]
    answer = []
    until queue.empty
      current = queue[0]
      if block_given? 
        yield current 
      else
        answer.push(current.data)
      end
      queue.push(current.l_child) if current.l_child
      queue.push(current.r_child) if current.r_child
      queue.pop
    end
    answer if answer
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
    answer if answer
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
    answer if answer
  end

  def postorder(node = @root)
    answer = []
    if block_given?
      yield node 
    else
      answer.push(node.data)
    end

    answer.push(preorder(node.l_child)) if node.l_child
    answer.push(preorder(node.r_child)) if node.r_child
    answer if answer
  end

  def height(node)
    heights = []

    heights.push(height(node.l_child)) if node.l_child
    heights.push(height(node.r_child)) if node.r_child

    heights.max
  end

  def depth(node)
    until node.data == current.data
      if node.data < current.l_child.data
        current = current.l_child
      else
        current = current.r_child
      end
      depth += 1
    end
    depth
  end

  def balanced?
    nodes = preorder
    leaf_heights = []
    nodes.foreach do |node| 
      leaf_heights.push(node.height) unless node.l_child || node.r_child 
    end
    if leaf_heights.max - leaf_heights.min > 1
      true
    else
      false
    end
  end

  def rebalance
    nodes = preorder
    @root = build_tree(nodes)
end