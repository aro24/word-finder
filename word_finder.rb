require 'flamegraph'

require_relative './file_reader.rb'
require_relative './graph.rb'

Flamegraph.generate('word_finder.html') do
  if ARGV.count == 1
    graphfile = ARGV[0]

    reader = FileReader.new graphfile
    nodes = reader.read_file
    exit 2 if nodes.nil?
    graph = Graph.new(nodes)

    graph.enumerate_paths

    graph.determine_permutations

    # we've established we can make a graph, and it works, now we can add the dictionary to another data structure
    dictionary = reader.read_dictionary('wordlist.txt') unless graph.nil?
    exit 3 if dictionary.nil?

    possible_words = []
    graph.word_list.each do |word|
      str = dictionary.key?(word.downcase)
      possible_words << word if str
    end

    longest_word_size = possible_words[possible_words.size - 1].size
    possible_words.each do |word|
      puts word if word.size == longest_word_size
    end
  else
    puts 'Run word_finder.rb with one file'
    exit 1
  end
end
