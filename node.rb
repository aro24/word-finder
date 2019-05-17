# Class to be used with graph. Stores each letter and the neighbors of the current instance
class Node
  attr_accessor :id, :letter, :neighbors
  def initialize(id, letter, neighbors)
    self.id = id
    self.letter = letter
    self.neighbors = neighbors
  end

  def num_neighbors
    neighbors.count
  end

  def alone?
    neighbors.count.zero?
  end

  def connected?
    neighbors.count.nonzero?
  end

  def add_neighbor(id)
    neighbors << id
  end

  def links_to_self?
    neighbors.include? id
  end

  def to_s
    neighbor_ids = connected? ? @neighbors.join(',') : '---'
    "Node #{id}: #{letter} [ #{neighbor_ids} ]"
  end
end
