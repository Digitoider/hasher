# frozen_string_literal: true

module Kernel
  class Hasherizer
    def to_h(node)
      if node.leaf?
        if node.is_a?(Hasher)
          return node.__to_h
        end
        return process_leaf(node)
      end


      result = {}
      node.children.each do |child_node|
        result.merge!(to_h(child_node))
      end
      result
    end

    protected

    def process_leaf(node)
      { node.key => node.value }
    end
  end
end
