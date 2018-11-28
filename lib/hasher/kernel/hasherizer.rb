# frozen_string_literal: true

module Kernel
  class Hasherizer
    def to_h(node)
      if node.leaf?
        if node.value.is_a?(Array)
          array = node.value.map do |elem|
            if elem.is_a?(::Kernel::Nodes::Base)
              to_h(elem)
            elsif elem.is_a?(Hasher)
              elem.to_h
            else
              elem
            end
          end
          return process_leaf(::Kernel::Nodes::Leaf.new(key: node.key, value: array))
        end
        if node.value.is_a?(Hasher)
          return node.to_h
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
