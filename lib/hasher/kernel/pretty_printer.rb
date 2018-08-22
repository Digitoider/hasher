# frozen_string_literal: true

module Kernel
  class PrettyPrinter
    def pretty_print(tree)
      pretty_print_recursive(tree)
    end

    def pretty_print_recursive(current_node, base_output = '')
      nodes_amount = current_node.nodes.count
      current_node.nodes.each_with_index do |node, index|
        return print_leaf(base_output, node.key, node.nodes[0]) if node.leaf?
        print_composite(base_output, node.key) if node.composite?
        pretty_print_recursive(node, format_base_output(base_output, nodes_amount, index))
      end
    end
%{

h = Hasher.new
h.a.b.c.d.e = 5
h.lat.lng.mandatory = 'coooool'
h.figure.it.out = {a: 1}
h.__pretty_print

}

    def format_base_output(base_output, nodes_amount, current_node_index)
      return "#{base_output}   " if nodes_amount == 1 || current_node_index == nodes_amount - 1
      return "#{base_output}#{pattern_branch_empty_last}" if current_node_index == nodes_amount - 1
      "#{base_output}#{pattern_branch_empty_not_last}"
    end

    def print_composite(base_output, key)
      puts "#{base_output}#{pattern_branch_ramificating}#{pattern_key(key)}"
    end

    def print_leaf(base_output, key, value)
      puts "#{base_output}#{pattern_branch_ramificating}#{pattern_key(key)}#{pattern_value(value)}"
    end

    def pattern_key(key)
      "#{key}"
    end

    def pattern_value(value)
      ": #{value}"
    end

    def print_s(base_output = '')
      puts "#{base_output}|--"
    end

    def pattern_branch_empty_last
      '+--'
    end

    def pattern_branch_empty_not_last
      '|  '
    end

    def pattern_branch_ramificating
      '+--'
    end

    def pattern_composite_node(key)
      put key
    end

    def count_leafs(current_node)
      count_leafs_recursive(current_node)
    end

    def count_leafs_recursive(current_node)
      return 1 if current_node.leaf?
      result = 0
      current_node.nodes.each do |node|
        result += count_leafs_recursive(node)
      end
      result
    end
  end
end
