#!/usr/bin/ruby

class Node < Struct.new(:name, :parent, :children)

  # finds a node with this name
  def find(name)
    # go to the root node
    current_node = self
    while current_node.parent != nil
      current_node = current_node.parent
    end

    current_node._find(name)
  end

  def _find(name)
    # start looking around
    if self.name == name
      return self
    end

    children.each_value do |node|
      found=node._find(name)
      if found != nil
        return found
      end
    end

    return nil
  end

  def stepsToRootNode()
    count = 0
    current_node = self
    while current_node.parent != nil
      current_node = current_node.parent
      count += 1
    end
    # now also count the children of this node
    if children != nil
      children.each_value do |child_node|
        count += child_node.stepsToRootNode()
      end
    end
    return count
  end

  def findPathTo(start_node, end_node)
    start_node_path = {}
    current_node = start_node
    count = 0
    while current_node.parent != nil
      start_node_path[current_node.name] = count
      current_node = current_node.parent
      count += 1
    end

    current_node = end_node
    count = 0
    end_node_path = {}
    while current_node != nil
      end_node_path[current_node.name] = count
      current_node = current_node.parent
      count += 1
    end

    minPath = -1
    start_node_path.each do |key, value|
      if end_node_path[key] != nil
        result = end_node_path[key] + value
        if minPath == -1 or result < minPath
          minPath = result
        end
      end
    end

    minPath
  end

end


def part1(map_data)
  rootNode = parse(map_data)
  rootNode.stepsToRootNode()
end

def part2(map_data)
  rootNode = parse(map_data)
  me = rootNode.find("YOU").parent
  san = rootNode.find("SAN").parent

  rootNode.findPathTo(me, san)
end

def parse(map_data)
  unparsed_nodes = {}
  map_data.each_line do |node_data|
    center = node_data.split(")")[0].strip
    orb = node_data.split(")")[1].strip
    unparsed_nodes[orb]=center
  end

  rootNode=Node.new("COM", nil)
  rootNode.children = findChildren(rootNode, unparsed_nodes)
  rootNode
end

def findChildren(parent_node, unparsed_nodes)
  child_nodes = {}
  key = unparsed_nodes.key(parent_node.name)
  while unparsed_nodes.delete(key) != nil
    node = Node.new(key, parent_node)
    node.children = findChildren(node, unparsed_nodes)

    child_nodes[key]=node

    key = unparsed_nodes.key(parent_node.name)
  end

  child_nodes
end

map_data=File.open("../input/day6.txt").read
map_data_example=File.open("../input/day6.example.1.txt").read

puts part1(map_data)
puts part2(map_data)

#puts part1(map_data_example)
