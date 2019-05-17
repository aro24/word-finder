require_relative './node.rb'
# Class to read graph file and
class FileReader
  def initialize(file)
    @file = file
  end

  def read_file
    unless File.exist?(@file)
      puts 'Enter a valid graph file'
      return nil
    end
    nodes = {}
    File.open(@file, 'r').each_line do |line|
      data = line.chomp.split(';')
      if data.count != 2 && data.count != 3
        puts 'Graph file has an error. Try another file.'
        return nil
      end
      id = data[0].to_i
      letter = data[1]
      neighbors = determine_neighbors(data)
      node = Node.new(id, letter, neighbors)
      nodes[node.id] = node
    end
    nodes
  end

  def read_dictionary(path)
    dictionary = {}
    unless File.exist?(path)
      puts 'File wordlist.txt not found. Please add to this directory.'
      return nil
    end
    File.open(path, 'r').each_line do |line|
      dictionary[line.chomp] = true
    end
    dictionary
  end

  def determine_neighbors(data)
    return [] if data.size == 2

    data[2].split(',').map(&:to_i)
  end
end
