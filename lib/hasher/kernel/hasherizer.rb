# frozen_string_literal: true

module Kernel
  class Hasherizer
    def self.to_hash(tree)
      to_hash_recursive(tree)
    end

    private

    def self.to_hash_recursive(tree)
      current_node_hash = {}
      tree.nodes.each do |node|
        current_node_hash[node.key] = node.nodes.first if node.leaf?
        current_node_hash[node.key] = to_hash_recursive(node) if node.composite?
      end
      current_node_hash
    end
  end
end
