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
        temp = minNode(node.r_child)
        node.data = temp.data
        node.r_child = delete(temp.data, node.r_child)
      end
    end
  end
  
  def minNode(node)
    min = node

    while min.l_child
      min = min.l_child
    end
    min
  end
end