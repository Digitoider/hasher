# frozen_string_literal: true

module Kernel
  module Nodes
    class Composite < Base
      def leaf?
        false
      end

      def composite?
        true
      end

      def children
        @children ||= []
      end

      def retrieve_child(key)
        children.find { |node| node.key == key }
      end

      def value=(node)
        found_child = children.find { |child| child.key == node.key }
        found_child.nil? ? children << node : found_child.value = node
      end

      def <<(node)
        found_child = children.find { |child| child.key == node.key }
        found_child.nil? ? children << node : found_child.value = node
      end
    end
  end
end
