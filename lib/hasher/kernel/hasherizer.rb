# frozen_string_literal: true

module Kernel
  module Hasherizers
    class MainType
      def to_h(node)
        found_hasherizer = hasherizers.find do |hasherizer|
          hasherizer.can_hasherize?(node)
        end

        found_hasherizer.to_h(node)
      end

      protected

      def hasherizers
        @hasherizers ||= [
          BasicType.new,
          CompositeNodeType.new,
          ArrayType.new,
          HasherType.new,
          DefaultType.new
        ]
      end
    end

    class CompositeNodeType
      def to_h(node)
        hash = {}
        node.children.each do |child_node|
          hash.merge!(main_hasherizer.to_h(child_node))
        end
        hash
      end

      def can_hasherize?(node)
        # how about node.is_a? ::Kernel::Nodes::Base
        node.respond_to?(:composite?) && node.composite?
      end

      private

      def main_hasherizer
        @main_hasherizer ||= ::Kernel::Hasherizers::MainType.new
      end
    end

    class ArrayType
      def to_h(node)
        main_hasherizer = ::Kernel::Hasherizers::MainType.new

        result = node.value.map do |n|
          main_hasherizer.to_h(n)
        end

        { node.key => result }
      end

      def can_hasherize?(node)
        node.value.is_a?(Array)
      end
    end

    class HasherType
      def to_h(node)
        hash = hasher?(node) ? node.to_h : node.value.to_h
        hash = {} if empty?(hash)
        node.key.nil? ? hash : { node.key => hash }
      end

      def can_hasherize?(node)
        hasher?(node) || node.respond_to?(:value) && node.value.is_a?(Hasher)
      end

      private

      def hasher?(node)
        node.is_a?(Hasher)
      end

      def empty?(hash)
        hash == { nil => nil }
      end
    end

    class BasicType
      def to_h(node)
        node
      end

      def can_hasherize?(node)
        denied_types.none? { |type| node.is_a?(type) }
      end

      private

      def denied_types
        [
          ::Hasher,
          ::Kernel::Nodes::Base
        ]
      end
    end

    class DefaultType
      def to_h(node)
        { node.key => node.value }
      end

      def can_hasherize?(_node)
        true
      end
    end
  end

  class Hasherizer
    def to_h(node)
      return ::Kernel::Hasherizers::MainType.new.to_h(node)
    end
  end
end
