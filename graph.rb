require_relative './node.rb'

# This is a simple graph class.
class Graph
  attr_accessor :nodes, :word_list, :perms

  def initialize(nodes)
    @nodes = nodes
    @word_list = []
    @perms = []
  end

  def num_nodes
    @nodes.keys.count
  end

  def node?(id)
    @nodes.key? id
  end

  def add_node(node)
    id = node.id
    @nodes[id] = node
    id
  end

  def pseudograph?
    @nodes.values.any?(&:links_to_self?)
  end

  def print
    if @nodes.keys.count.zero?
      puts 'Empty graph!'
    else
      @nodes.each do |_, val|
        puts val
      end
    end
  end

  def enumerate_paths
    @nodes.each do |_, node|
      make_word(node, '') unless node.nil?
    end
    list = @word_list
    list
  end

  def make_word(node, str)
    str += node.letter
    if node.neighbors.empty?
      @word_list << str
    else
      neighbors = node.neighbors
      neighbors.each do |n|
        make_word(@nodes[n], str)
      end
    end
  end

  def determine_permutations
    @word_list.each do |word|
      permutate(word)
    end
    @perms.each do |perm|
      @word_list << perm
    end
    @word_list = @word_list.uniq.sort_by(&:length)
  end

  # may be getting too many permutations
  # ex:
  # vhcwyma will also give ca, ma, my
  def permutate(word)
    max_size = word.size
    perms_arr = word.chars.permutation.map(&:join)
    perms_arr.each do |perm|
      @perms << perm if perm.size == max_size
    end
  end
end
