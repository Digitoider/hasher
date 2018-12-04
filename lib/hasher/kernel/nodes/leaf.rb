# frozen_string_literal: true

module Kernel
  module Nodes
    class Leaf < Base
      def leaf?
        true
      end

      def composite?
        false
      end

      def value=(node)
        @value = node.value
      end

      def value
        return @value unless @value.is_a?(Array)

        return_value = @value.map do |elem|
          elem.is_a?(Base) ? elem.value : elem
        end

        return_value = ArraySubstitute.new(return_value)
        return_value.reference_original = @value
        return_value
      end
    end

    class ArraySubstitute < Array
      attr_accessor :reference_original

      def <<(elem)
        # binding.pry
        resolve_push(elem)
      end

      def push(elem)
        resolve_push(elem)
      end

      private

      def resolve_push(elem)
        binding.pry if elem == {d: 'yeah!'}
        node = main_resolver.resolve(value: elem)
        @reference_original << node
      end

      def main_resolver
        @main_resolver ||= ::Kernel::Resolvers::MainResolver.new
      end
    end
  end
end
