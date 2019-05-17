# Note that we require and start simplecov before
# doing ANYTHING else, including other require statements.
require 'simplecov'
SimpleCov.start

# Previous code starts here!

require 'minitest/autorun'

require_relative 'graph'
require_relative 'node'
require_relative 'file_reader'

# Test class for the graph
class WordFinderTest < Minitest::Test
  # Special method!
  # This will run the following code before each test
  # We will re-use the @g instance variable in each method
  # This was we don't have to type g = Graph::new in each test

  def setup
    node_hash = {}
    @g = Graph.new node_hash
    @n = Node.new 1, 'Z', []
  end

  # Creates a graph, refutes that it's nil, and asserts that it is a
  # kind of Graph object.

  def test_new_graph_not_nil
    refute_nil @g
    assert_kind_of Graph, @g
  end

  # This is a "regular" add node test.
  # We are checking to see if we add a node, does the graph report
  # the correct number of nodes.
  # Note though that we now have a dependency on the Node class now,
  # even though we are testing

  def test_add_node
    n = Node.new 1, 'A', [2, 3]

    @g.add_node n

    assert_equal @g.num_nodes, 1
  end

  # Create a node which is not part of the graph and refute (opposite
  # of assert) that it is in the graph.  That is, if we do not add
  # to the graph, it should not be in there
  def test_has_node_dummy_with_obj
    nonexistent_node = Node.new 1, 'B', [2]
    refute @g.node? nonexistent_node
  end

  # Verify that an empty node prints out "Empty graph!" when
  # print method is called.

  def test_print_empty
    assert_output(/Empty graph!/) { @g.print }
  end

  # Verify that a graph with one node prints out correctly
  def test_print_one_node
    @g.add_node Node.new 1, 'C', [1]
    assert_output("Node 1: C [ 1 ]\n") { @g.print }
  end

  # Verify that a graph with multiple nodes prints out correctly
  def test_print_multiple_nodes
    @g.add_node Node.new 1, 'D', [2]
    @g.add_node Node.new 2, 'E', [2, 3]
    @g.add_node Node.new 3, 'F', [1]
    assert_output("Node 1: D [ 2 ]\nNode 2: E [ 2,3 ]\nNode 3: F [ 1 ]\n") { @g.print }
  end

  # Verify that a pseudograph is correctly identified
  def test_pseudograph
    n = Node.new 1, 'I', [1]
    @g.add_node n
    assert @g.pseudograph?
  end

  # Verify that a non-pseudograph is correctly identified
  def test_non_pseudograph
    @g.add_node Node.new 1, 'G', [2]
    @g.add_node Node.new 2, 'H', [1]
    refute @g.pseudograph?
  end

  # Tests that a string returns its permutations
  def test_permutate
    word = 'HE'
    @g.permutate word
    assert_equal @g.perms, %w[HE EH]
  end

  def test_make_word
    n = Node.new 1, 'A', [2]
    n2 = Node.new 2, 'B', []
    @g.add_node n
    @g.add_node n2
    @g.make_word(n, '')
    assert_equal @g.word_list, ['AB']
  end

  #  NODE TESTS

  # Tests that the correct number of neighbors are recorded
  def test_num_neighbors
    assert_equal @n.num_neighbors, 0
  end

  # Tests that nodes that are alone return true, opposite of connected?
  def test_alone
    assert @n.alone?
  end

  # Tests that nodes that are not connected return false, opposite of alone?
  def test_connected
    refute @n.connected?
  end

  # Tests that adding a neighbor will, in fact, change the neighbors array of node
  def test_add_neighbor
    @n.add_neighbor 7
    assert_equal @n.neighbors.count, 1
  end

  # Tests that a node without itself as a neighbor returns false
  def test_not_links_to_self
    refute @n.links_to_self?
  end

  # Tests that a node with itself as a neighbor returns true
  def test_links_to_self
    othernode = Node.new 2, 'Y', [2]
    assert othernode.links_to_self?
  end

  # Tests that printing a node with no neighbors results with '[ --- ]' printing
  def test_to_s_node
    assert_equal 'Node 1: Z [ --- ]', @n.to_s
  end

  # Tests that printing a node with neighbors results with the neighbors printing.
  def test_to_s_node_with_neighbors
    othernode = Node.new 2, 'Y', [3, 4]
    assert_equal 'Node 2: Y [ 3,4 ]', othernode.to_s
  end

  # FILE READER TESTS

  # tests that the neighbor data returned is an array
  def test_determine_neighbors
    reader = FileReader.new('small_graph.txt')
    str = ['1', 'C', '2,3']
    assert_equal reader.determine_neighbors(str), [2, 3]
  end

  # tests that no neighbor data returns an empty array
  def test_determine_no_neighbors
    reader = FileReader.new('small_graph.txt')
    str = %w[2 D]
    assert_equal reader.determine_neighbors(str), []
  end

  # tests that the dictionary is stored propperly
  def test_read_dictionary
    reader = FileReader.new('small_graph.txt')
    dict = reader.read_dictionary('testfiles/testlist.txt')
    assert_equal dict.keys, %w[a big collar]
  end

  def test_read_no_dictionary
    reader = FileReader.new('small_graph.txt')
    assert_output("File wordlist.txt not found. Please add to this directory.\n") { reader.read_dictionary('t') }
  end

  # tests that a file is read correctly
  def test_read_file
    reader = FileReader.new('testfiles/testgood.txt')
    testnodes = reader.read_file
    realnodes = {}
    realnodes[1] = Node.new 1, 'A', [2, 3]
    realnodes[2] = Node.new 2, 'C', [3]
    realnodes[3] = Node.new 3, 'D', []
    realarr = realnodes.values
    testarr = testnodes.values
    assert_equal realnodes.keys, testnodes.keys
    assert_equal realarr[0].id, testarr[0].id
    assert_equal realarr[0].letter, testarr[0].letter
    assert_equal realarr[0].neighbors, testarr[0].neighbors
  end

  # tests that an invalid file is handled correctly
  def test_invalid_read_file
    reader = FileReader.new('notafile.rb')
    assert_output("Enter a valid graph file\n") { reader.read_file }
  end

  # tests that a miscellaneous file is handled correctly
  def test_misc_read_file
    reader = FileReader.new('testfiles/testbad.txt')
    assert_output("Graph file has an error. Try another file.\n") { reader.read_file }
  end
end
