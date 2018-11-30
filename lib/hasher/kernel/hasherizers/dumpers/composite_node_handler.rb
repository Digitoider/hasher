# frozen_string_literal: true

module Kernel
  module Hasherizers
    module Dumpers
      class CompositeNodeHandler
        def to_h(node)
          hash = {}
          node.children.each do |child_node|
            hash.merge!(main_hasherizer.to_h(child_node))
          end
          hash
        end

        def can_hasherize?(node)
          node.is_a?(::Kernel::Nodes::Base) && node.composite?
        end

        private

        def main_hasherizer
          @main_hasherizer ||= ::Kernel::Hasherizers::Dumpers::MainDumper.new
        end
      end
    end
  end
end
