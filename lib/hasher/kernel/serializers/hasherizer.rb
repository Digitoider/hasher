# frozen_string_literal: true

module Kernel
  module Serializers
    class Hasherizer
      def self.to_hash(tree)
        return tree unless tree.is_a?(::Kernel::Tree)
        return tree.value if tree.leaf?
        result = {}
        tree.nodes.each do |node|
          result.merge!(node.key => to_hash(node))
        end
        result
      end
    end
  end
end
